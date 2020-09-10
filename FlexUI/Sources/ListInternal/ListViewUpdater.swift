//
//  ListViewUpdater.swift
//  YogaUI
//
//  Created by 黎昌明 on 2020/8/21.
//

import Foundation
import DifferenceKit

public final class ListViewUpdater {
  public var animatableChangeCount:Int = 300
  public var keepsContentOffset: Bool = true

  fileprivate enum UpdateContent {
    case changed(data: [Section], stagedChangeset: StagedChangeset<[Section]>)
    case reload(data: [Section], isStatic: Bool)
  }

  lazy var layoutQueue:OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()

  func prepare(for listView: ListView, adapter: ListViewAdapter) {
    listView.setup(with: adapter)
  }

  func performUpdate(with listView: ListView, adapter: ListViewAdapter, data: [Section]) {
    let isStatic: Bool = data.first?.cells.first?.isDefaultID ?? false
    adapter.isStaticLayout = isStatic
    guard listView.window != nil else {
      layout(with: listView, adapter: adapter, updateContent: .reload(data: data, isStatic: isStatic)) { (content) in
        if case .reload(let data, _) = content {
          adapter.data = data
          adapter.reloadData()
        }
      }
      return
    }

    if adapter.data.isEmpty {
      layout(with: listView, adapter: adapter, updateContent: .reload(data: data, isStatic: isStatic)) { (content) in
        if case .reload(let data, _) = content {
          adapter.data = data
          adapter.reloadData()
        }
      }
      return
    }


    let stagedChangeset = StagedChangeset(source: adapter.data, target: data)
    if stagedChangeset.isEmpty {
      return
    }

    let totalChangedCound = stagedChangeset.reduce(0) { (total, next) in
      total + next.changeCount
    }
    if totalChangedCound >= self.animatableChangeCount {
      layout(with: listView, adapter: adapter, updateContent: .reload(data: data, isStatic: isStatic)) { (content) in
        if case .reload(let data, _) = content {
          adapter.data = data
          adapter.reloadData()
        }
      }
      return
    }

    layout(with: listView, adapter: adapter, updateContent: .changed(data: data, stagedChangeset: stagedChangeset)) { (content) in
      if case .changed(_, let change) = content {
        CATransaction.begin()
        self.performDiffenrentialUpdates(in: listView, adapter: adapter, stagedChangeset: change)
        CATransaction.commit()
      }
    }
  }

  private func performDiffenrentialUpdates(in listView: ListView, adapter: ListViewAdapter, stagedChangeset: StagedChangeset<[Section]>) {
    let prevContentOffset = listView.contentOffset
    let updates = ListUpdates()
    for changeset in stagedChangeset {
      updates.deleteSections = .init(changeset.sectionDeleted)
      updates.insertSections = .init(changeset.sectionInserted)
      updates.reloadSections = .init(changeset.sectionUpdated)
      updates.moveSections = changeset.sectionMoved.map { (source: Int, target: Int) -> ListUpdates.Move<Int> in
        return .init(from: source, to: target)
      }

      updates.deleteItems = changeset.elementDeleted.map { IndexPath(row: $0.element, section: $0.section) }
      updates.insertItems = changeset.elementInserted.map { IndexPath(row: $0.element, section: $0.section) }
      updates.reloadItems = changeset.elementUpdated.map { IndexPath(row: $0.element, section: $0.section) }
      updates.moveItems = changeset.elementMoved.map { (source: ElementPath, target: ElementPath) -> ListUpdates.Move<IndexPath> in
        return .init(from: IndexPath(row: source.element, section: source.section), to: IndexPath(row: target.element, section: target.section))
      }
      adapter.data = changeset.data
      adapter.performBatchUpdate(updates)
    }
    if keepsContentOffset {
      listView.adjustContentOffsetIfNeeded(prevContentOffset)
    }
  }

  private func layout(with listView: ListView, adapter: ListViewAdapter, updateContent: UpdateContent, completion: @escaping (UpdateContent) -> Void) {
    let width = listView.bounds.width
    let direction = listView.direction
    layoutQueue.addOperation {
      var staticLayoutStorage = [Int : [Int : FlexTree]]()
      var dynamicLayoutStorage = [AnyHashable: FlexTree]()
      switch updateContent {
      case .changed(let data, let stagedChangeset):
        for changeset in stagedChangeset {
          for index in changeset.sectionInserted {
            let section = data[index]
            if let node = section.header {
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node.id] = tree
            }
            if let node = section.footer {
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node.id] = tree
            }
            for cellIndex in 0..<section.cells.count {
              let node = section.cells[cellIndex]
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node.id] = tree
            }
          }
          for index in changeset.sectionUpdated {
            let section = data[index]
            if let node = section.header {
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node.id] = tree
            }
            if let node = section.footer {
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node.id] = tree
            }
            for cellIndex in 0..<section.cells.count {
              let node = section.cells[cellIndex]
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node.id] = tree
            }
          }
          for index in changeset.sectionDeleted {
//            layoutStorage.deleteTrees(forSection: index)
//              dynamicLayoutStorage[node.id] = tree
          }

          for indexPath in changeset.elementInserted {
            let node = data[indexPath.section].cells[indexPath.element]
            let tree = node.buildAndCalculateLayout(width: width, direction: direction)
            dynamicLayoutStorage[node.id] = tree
          }
          for indexPath in changeset.elementUpdated {
            let node = data[indexPath.section].cells[indexPath.element]
            let tree = node.buildAndCalculateLayout(width: width, direction: direction)
            dynamicLayoutStorage[node.id] = tree
          }
          for indexPath in changeset.elementDeleted {
//            layoutStorage.deleteTree(forCellAt: (IndexPath(item: indexPath.element, section: indexPath.section)))
          }
        }
      case .reload(let data, let isStatic):
        if isStatic {
          for sectionIndex in 0..<data.count {
            let section = data[sectionIndex]
            if let node = section.header {
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              staticLayoutStorage[sectionIndex, default: [:]][ListViewAdapter.StorageSectionHeaderIndex] = tree
            }
            if let node = section.footer {
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              staticLayoutStorage[sectionIndex, default: [:]][ListViewAdapter.StorageSectionFooterIndex] = tree
            }
            for cellIndex in 0..<section.cells.count {
              let node = section.cells[cellIndex]
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              staticLayoutStorage[sectionIndex, default: [:]][cellIndex] = tree
            }
          }
        } else {
          for sectionIndex in 0..<data.count {
            let section = data[sectionIndex]

            if let node = section.header {
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node.id] = tree
            }
            if let node = section.footer {
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node.id] = tree
            }
            for cellIndex in 0..<section.cells.count {
              let node = section.cells[cellIndex]
              let tree = node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node.id] = tree
            }
          }
        }
      }
      DispatchQueue.main.async {
        switch updateContent {
        case .changed: 
          for (id, tree) in dynamicLayoutStorage {
            adapter.dynamicLayoutStorage[id] = tree
          }
        case .reload(_, let isStatic):
          if isStatic {
            for (sectionIndex, section) in staticLayoutStorage {
              for (cellIndex, tree) in section {
                adapter.staticLayoutStorage[sectionIndex, default: [:]][cellIndex] = tree
              }
            }
          } else {
            for (id, tree) in dynamicLayoutStorage {
              adapter.dynamicLayoutStorage[id] = tree
            }
          }
        }
        completion(updateContent)
      }
    }

  }

}

extension AnyNode {
  fileprivate func buildAndCalculateLayout(width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude, direction: Direction) -> FlexTree {
    return buildFlexTree().calculateLayout(width: width, height: height, direction: direction)
  }
}
