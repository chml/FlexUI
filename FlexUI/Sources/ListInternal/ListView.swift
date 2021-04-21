//
//  ListView.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/31.
//

import UIKit

public protocol ListView: UIView {

  var contentOffset: CGPoint { get }

  var isTracking: Bool { get }

  var isDecelerating: Bool { get }

  var refreshControl: UIRefreshControl?  { get set }

  func reloadData()

  func performBatchUpdates(_ updates: ListUpdates, completion: (() -> Void)?)

  var listAdapter: ListViewAdapter? { get  set }

  func setup(with adapter: ListViewAdapter)

  func registerCell(for viewClass: AnyClass?, reuseID: String)
  func registerHeaderFooterView(for viewClass: AnyClass?, kind: String?, reuseID: String)

  func adjustContentOffsetIfNeeded(_ offset: CGPoint)

  var infiniteScrollFooter: InfiniteScrollFooter { get }

}

public class ListUpdates {

  public struct Move<Index: Equatable>: Equatable {
    public let from: Index
    public let to: Index
    public init(from: Index, to: Index) {
      self.from = from
      self.to = to
    }
  }

  public var insertItems = [IndexPath]()
  public var deleteItems = [IndexPath]()
  public var reloadItems = [IndexPath]()
  public var moveItems = [Move<IndexPath>]()
  public var insertSections = IndexSet()
  public var deleteSections = IndexSet()
  public var reloadSections = IndexSet()
  public var moveSections = [Move<Int>]()

  public init() { }
}


private struct AssociatedKey {
  static var listAdapter: Int8 = 0
}

extension ListView {

  public var listAdapter: ListViewAdapter? {
    get { objc_getAssociatedObject(self, &AssociatedKey.listAdapter) as? ListViewAdapter }
    set {
      objc_setAssociatedObject(self, &AssociatedKey.listAdapter, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }

}

extension ListView where Self: UIScrollView {

  public func adjustContentOffsetIfNeeded(_ offset: CGPoint) {
    setAdjustedContentOffsetIfNeeded(offset)
  }

}

extension ListView where Self: UICollectionView {
  public func setup(with adapter: ListViewAdapter) {
    listAdapter = adapter
    dataSource = adapter
    delegate = adapter
  }
}

extension ListView where Self: UITableView {
  public func setup(with adapter: ListViewAdapter) {
    listAdapter = adapter
    dataSource = adapter
    delegate = adapter
  }
}


extension UITableView: ListView {

  public func registerCell(for viewClass: AnyClass?, reuseID: String) {
    register(viewClass, forCellReuseIdentifier: reuseID)
  }

  public func registerHeaderFooterView(for viewClass: AnyClass?, kind: String? = nil, reuseID: String) {
    register(viewClass, forHeaderFooterViewReuseIdentifier: reuseID)
  }

  public func performBatchUpdates(_ updates: ListUpdates, completion: (() -> Void)? = nil) {
    func performUpdate() {
      if !updates.insertItems.isEmpty {
        insertRows(at: updates.insertItems, with: .fade)
      }
      if !updates.deleteItems.isEmpty {
        deleteRows(at: updates.deleteItems, with: .fade)
      }
      if !updates.reloadItems.isEmpty {
        reloadRows(at: updates.reloadItems, with: .none)
      }
      for move in updates.moveItems {
        moveRow(at: move.from, to: move.to)
      }

      if !updates.insertSections.isEmpty {
        insertSections(updates.insertSections, with: .fade)
      }
      if !updates.deleteSections.isEmpty {
        deleteSections(updates.deleteSections, with: .fade)
      }
      if !updates.reloadSections.isEmpty {
        reloadSections(updates.reloadSections, with: .fade)
      }
      for move in updates.moveSections {
        moveSection(move.from, toSection: move.to)
      }
    }

    if #available(iOS 11.0, *) {
      performBatchUpdates({
        performUpdate()
      }) { (_) in
        completion?()
      }
    } else {
      beginUpdates()
      performUpdate()
      endUpdates()
      completion?()
    }
  }

}

extension UICollectionView: ListView {

  public func registerCell(for viewClass: AnyClass?, reuseID: String) {
    register(viewClass, forCellWithReuseIdentifier: reuseID)
  }

  public func registerHeaderFooterView(for viewClass: AnyClass?, kind: String? = nil, reuseID: String) {
    register(viewClass, forSupplementaryViewOfKind: kind ?? UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseID)
    register(viewClass, forSupplementaryViewOfKind: kind ?? UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseID)
  }

  public func performBatchUpdates(_ updates: ListUpdates, completion: (() -> Void)? = nil) {
    performBatchUpdates({
      if !updates.insertItems.isEmpty {
        self.insertItems(at: updates.insertItems)
      }
      if !updates.deleteItems.isEmpty {
        self.deleteItems(at: updates.deleteItems)
      }
      if !updates.reloadItems.isEmpty {
        self.reloadItems(at: updates.reloadItems)
      }
      for move in updates.moveItems {
        self.moveItem(at: move.from, to: move.to)
      }

      if !updates.insertSections.isEmpty {
        self.insertSections(updates.insertSections)
      }
      if !updates.deleteSections.isEmpty {
        self.deleteSections(updates.deleteSections)
      }
      if !updates.reloadSections.isEmpty {
        self.reloadSections(updates.reloadSections)
      }
      for move in updates.moveSections {
        self.moveSection(move.from, toSection: move.to)
      }
    }) { (_) in
      completion?()
    }

  }

}

