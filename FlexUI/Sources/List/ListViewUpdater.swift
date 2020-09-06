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
    case changed([Section], StagedChangeset<[Section]>)
    case reload([Section])
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
    guard listView.window != nil else {
      layout(with: listView, adapter: adapter, updateContent: .reload(data)) { (content) in
        if case .reload(let data) = content {
          adapter.data = data
          adapter.reloadData()
        }
      }
      return
    }

    if adapter.data.isEmpty {
      layout(with: listView, adapter: adapter, updateContent: .reload(data)) { (content) in
        if case .reload(let data) = content {
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
      layout(with: listView, adapter: adapter, updateContent: .reload(data)) { (content) in
        if case .reload(let data) = content {
          adapter.data = data
          adapter.reloadData()
        }
      }
      return
    }

    layout(with: listView, adapter: adapter, updateContent: .changed(data, stagedChangeset)) { (content) in
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
    layoutQueue.addOperation {
      let layoutStorage = adapter.layoutStorage//ListLayoutStorage()
      switch updateContent {
      case .changed(let data, let stagedChangeset):
        for changeset in stagedChangeset {
          for index in changeset.sectionInserted {
            let section = data[index]
            if let tree = section.header?.buildAndCalculateLayout(width: width) {
              layoutStorage.setTree(tree, forHeaderAt: index)
            }
            if let tree = section.footer?.buildAndCalculateLayout(width: width) {
              layoutStorage.setTree(tree, forFooterAt: index)
            }
            for cellIndex in 0..<section.cells.count {
              let cell = section.cells[cellIndex]
              let tree = cell.buildAndCalculateLayout(width: width)
              layoutStorage.setTree(tree, forCellAt: IndexPath(item: cellIndex, section: index))
            }
          }
          for index in changeset.sectionUpdated {
            let section = data[index]
            if let tree = section.header?.buildAndCalculateLayout(width: width) {
              layoutStorage.setTree(tree, forHeaderAt: index)
            }
            if let tree = section.footer?.buildAndCalculateLayout(width: width) {
              layoutStorage.setTree(tree, forFooterAt: index)
            }
            for cellIndex in 0..<section.cells.count {
              let cell = section.cells[cellIndex]
              let tree = cell.buildAndCalculateLayout(width: width)
              layoutStorage.setTree(tree, forCellAt: IndexPath(item: cellIndex, section: index))
            }
          }
          for index in changeset.sectionDeleted {
            layoutStorage.deleteTrees(forSection: index)
          }

          for indexPath in changeset.elementInserted {
            let cell = data[indexPath.section].cells[indexPath.element]
            let tree = cell.buildAndCalculateLayout(width: width)
            layoutStorage.setTree(tree, forCellAt: IndexPath(item: indexPath.element, section: indexPath.section))
          }
          for indexPath in changeset.elementUpdated {
            let cell = data[indexPath.section].cells[indexPath.element]
            let tree = cell.buildAndCalculateLayout(width: width)
            layoutStorage.setTree(tree, forCellAt: IndexPath(item: indexPath.element, section: indexPath.section))
          }
          for indexPath in changeset.elementDeleted {
            layoutStorage.deleteTree(forCellAt: (IndexPath(item: indexPath.element, section: indexPath.section)))
          }
        }
      case .reload(let data):
        for sectionIndex in 0..<data.count {
          let section = data[sectionIndex]

          if let tree = section.header?.buildAndCalculateLayout(width: width) {
            layoutStorage.setTree(tree, forHeaderAt: sectionIndex)
          }
          if let tree = section.footer?.buildAndCalculateLayout(width: width) {
            layoutStorage.setTree(tree, forFooterAt: sectionIndex)
          }
          for cellIndex in 0..<section.cells.count {
            let cell = section.cells[cellIndex]
            let tree = cell.buildAndCalculateLayout(width: width)
            layoutStorage.setTree(tree, forCellAt: IndexPath(item: cellIndex, section: sectionIndex))
          }
        }
      }
      DispatchQueue.main.async {
//        layoutStorage.storage.forEach {
//
//        }
        completion(updateContent)
      }
    }

  }

}

extension AnyNode {
  fileprivate func buildAndCalculateLayout(width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude) -> FlexTree {
    return buildFlexTree().calculateLayout(width: width, height: height, direction: .inherit)
  }
}
