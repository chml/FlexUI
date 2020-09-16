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
    let isStatic: Bool = data.first?.cells.first?.baseIDIsDefault ?? false

    func reload() {
      layout(with: listView, adapter: adapter, updateContent: .reload(data: data, isStatic: isStatic)) { (content) in
        if case .reload(let data, _) = content {
          adapter.data = data
          adapter.reloadData()
        }
      }
    }

    adapter.isStaticLayout = isStatic
    if isStatic || adapter.data.isEmpty || listView.window == nil {
      reload()
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
      reload()
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
    let direction = (listView as UIView).flex.direction
    let oldDynamicLayoutStorage = adapter.dynamicLayoutStorage
    layoutQueue.addOperation {
      var staticLayoutStorage = [Int : [Int : FlexTree]]()
      var dynamicLayoutStorage = [AnyHashable: FlexTree]()
      switch updateContent {
      case .changed(let data, _):
        for sectionIndex in 0..<data.count {
          let section = data[sectionIndex]

          if let node = section.header {
            let tree = oldDynamicLayoutStorage[node] ?? node.buildAndCalculateLayout(width: width, direction: direction)
            dynamicLayoutStorage[node] = tree
          }
          if let node = section.footer {
            let tree = oldDynamicLayoutStorage[node] ?? node.buildAndCalculateLayout(width: width, direction: direction)
            dynamicLayoutStorage[node] = tree
          }
          for cellIndex in 0..<section.cells.count {
            let node = section.cells[cellIndex]
            let tree =  oldDynamicLayoutStorage[node] ?? node.buildAndCalculateLayout(width: width, direction: direction)
            dynamicLayoutStorage[node] = tree
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
              let tree = oldDynamicLayoutStorage[node] ?? node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node] = tree
            }
            if let node = section.footer {
              let tree = oldDynamicLayoutStorage[node] ?? node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node] = tree
            }
            for cellIndex in 0..<section.cells.count {
              let node = section.cells[cellIndex]
              let tree = oldDynamicLayoutStorage[node] ?? node.buildAndCalculateLayout(width: width, direction: direction)
              dynamicLayoutStorage[node] = tree
            }
          }
        }
      }
      DispatchQueue.main.async {
        switch updateContent {
        case .changed:
          adapter.dynamicLayoutStorage = dynamicLayoutStorage
        case .reload(_, let isStatic):
          if isStatic {
            adapter.staticLayoutStorage = staticLayoutStorage
          } else {
            adapter.dynamicLayoutStorage = dynamicLayoutStorage
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