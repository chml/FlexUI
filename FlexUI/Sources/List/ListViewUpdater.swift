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

  lazy var layoutQueue:OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()

  func prepare(for listView: ListView, adapter: ListViewAdapter) {
    listView.setup(with: adapter)
  }

  func performUpdate(with listView: ListView, adapter: ListViewAdapter, data: [Section]) {

    layout(with: listView, data: data) { (data) in
      
      guard listView.window != nil else {
        adapter.data = data
        adapter.reloadData()
        return
      }

      if adapter.data.isEmpty {
        adapter.data = data
        adapter.reloadData()
        return
      }

      let stagedChangeset = StagedChangeset(source: adapter.data, target: data)
      if stagedChangeset.isEmpty {
        adapter.data = data
        return
      }

      let totalChangedCound = stagedChangeset.reduce(0) { (total, next) in
        total + next.changeCount
      }
      if totalChangedCound >= self.animatableChangeCount {
        adapter.data = data
        adapter.reloadData()
        return
      }

      CATransaction.begin()
      self.performDiffenrentialUpdates(in: listView, adapter: adapter, stagedChangeset: stagedChangeset)
      CATransaction.commit()

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

  private func layout(with listView: ListView, data: [Section], completion: @escaping ([Section]) -> Void) {
    let width = listView.bounds.width
    let direction = listView.direction
    layoutQueue.cancelAllOperations()
    layoutQueue.addOperation {
      for section in data {
        section.header?.calculateLayout(width: width, direction: direction)
        section.footer?.calculateLayout(width: width, direction: direction)
        for cell in section.cells {
          cell.calculateLayout(width: width, direction: direction)
        }
      }
      DispatchQueue.main.async {
        completion(data)
      }
    }
  }

}
