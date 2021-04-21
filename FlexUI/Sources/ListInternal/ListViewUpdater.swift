//
//  ListViewUpdater.swift
//  YogaUI
//
//  Created by Li ChangMing on 2020/8/21.
//

import Foundation
import DifferenceKit


public final class ListViewUpdater {
  public var animatableChangeCount:Int = 50
  public var keepsContentOffset: Bool = true
  public var alwaysReload: Bool = false

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
        if self.alwaysReload {
          adapter.reloadData()
        } else {
          CATransaction.begin()
          self.performDiffenrentialUpdates(in: listView, adapter: adapter, stagedChangeset: change)
          CATransaction.commit()
        }
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
    let boundsSize = listView.bounds.size
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
            let tree = oldDynamicLayoutStorage[node] ?? buildAndCalculateLayout(with: node, boundsSize: boundsSize, direction: direction)
            dynamicLayoutStorage[node] = tree
          }
          if let node = section.footer {
            let tree = oldDynamicLayoutStorage[node] ?? buildAndCalculateLayout(with: node, boundsSize: boundsSize, direction: direction)
            dynamicLayoutStorage[node] = tree
          }
          for cellIndex in 0..<section.cells.count {
            let node = section.cells[cellIndex]
            let tree =  oldDynamicLayoutStorage[node] ?? buildAndCalculateLayout(with: node, boundsSize: boundsSize, direction: direction)
            dynamicLayoutStorage[node] = tree
          }
        }
      case .reload(let data, let isStatic):
        if isStatic {
          for sectionIndex in 0..<data.count {
            let section = data[sectionIndex]
            if let node = section.header {
              let tree = buildAndCalculateLayout(with: node, boundsSize: boundsSize, direction: direction)
              staticLayoutStorage[sectionIndex, default: [:]][ListViewAdapter.StorageSectionHeaderIndex] = tree
            }
            if let node = section.footer {
              let tree = buildAndCalculateLayout(with: node, boundsSize: boundsSize, direction: direction)
              staticLayoutStorage[sectionIndex, default: [:]][ListViewAdapter.StorageSectionFooterIndex] = tree
            }
            for cellIndex in 0..<section.cells.count {
              let node = section.cells[cellIndex]
              let tree = buildAndCalculateLayout(with: node, boundsSize: boundsSize, direction: direction)
              staticLayoutStorage[sectionIndex, default: [:]][cellIndex] = tree
            }
          }
        } else {
          for sectionIndex in 0..<data.count {
            let section = data[sectionIndex]

            if let node = section.header {
              let tree = oldDynamicLayoutStorage[node] ?? buildAndCalculateLayout(with: node, boundsSize: boundsSize, direction: direction)
              dynamicLayoutStorage[node] = tree
            }
            if let node = section.footer {
              let tree = oldDynamicLayoutStorage[node] ?? buildAndCalculateLayout(with: node, boundsSize: boundsSize, direction: direction)
              dynamicLayoutStorage[node] = tree
            }
            for cellIndex in 0..<section.cells.count {
              let node = section.cells[cellIndex]
              let tree = oldDynamicLayoutStorage[node] ?? buildAndCalculateLayout(with: node, boundsSize: boundsSize, direction: direction)
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

private func buildAndCalculateLayout(with node: AnyNode, boundsSize: CGSize, direction: Direction) -> FlexTree {
  let tree = node.buildFlexTree()
  var width: CGFloat = .greatestFiniteMagnitude
  var height: CGFloat = .greatestFiniteMagnitude
  let wrappedNode = tree.node.findWrappedContentChild() ?? tree.node
  let nodeMaxWidth = wrappedNode.style.maxWidth
  if nodeMaxWidth.unit != .undefined {
    if nodeMaxWidth.unit == .point {
      width = nodeMaxWidth.value.cgFloat
    } else if nodeMaxWidth.unit == .percent {
      width = boundsSize.width * nodeMaxWidth.value.cgFloat / 100
    }
  }
  let nodeWidth = wrappedNode.style.width
  if nodeWidth.unit != .auto {
    if nodeWidth.unit == .point {
      width = nodeWidth.value.cgFloat
    } else if nodeWidth.unit == .percent {
      width = boundsSize.width * nodeWidth.value.cgFloat / 100
    }
  }

  let nodeMaxHeight = wrappedNode.style.maxHeight
  if nodeMaxHeight.unit != .undefined {
    if nodeMaxHeight.unit == .point {
      height = nodeMaxHeight.value.cgFloat
    } else if nodeMaxHeight.unit == .percent {
      height = boundsSize.height * nodeMaxHeight.value.cgFloat / 100
    }
  }

  let nodeHeight = wrappedNode.style.height
  if nodeHeight.unit != .auto {
    if nodeHeight.unit == .point {
      height = nodeHeight.value.cgFloat
    } else if nodeHeight.unit == .percent {
      height = boundsSize.height * nodeHeight.value.cgFloat / 100
    }
  }
  if width == .greatestFiniteMagnitude && height == .greatestFiniteMagnitude {
    width = boundsSize.width
  }

  tree.ignoreWrappedSizing = true
  tree.calculateLayout(width: width, height: height, direction: direction)
  return tree
}
