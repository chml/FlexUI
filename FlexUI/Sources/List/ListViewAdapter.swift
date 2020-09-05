//
//  ListViewAdapter.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/31.
//

public final class ListViewAdapter: NSObject {

  var data: [Section] = []
  var onSelect: ((AnyNode, IndexPath) -> Void)? = nil
  public var autoDeselect: Bool = true
  lazy var updater: ListViewUpdater = ListViewUpdater()

  public weak var listView: ListView? {
    didSet {
      if let listView = listView {
        updater.prepare(for: listView, adapter: self)
      }
    }
  }

  public func render<C: Collection>(_ data: C) where C.Element == Section {
    guard let listView = listView else {
      return
    }
    let array = Array(data)
    updater.performUpdate(with: listView, adapter: self, data: array)
  }

  func reloadData() {
    listView?.reloadData()
  }
  
  func performBatchUpdate(_ updates: ListUpdates) {
    listView?.performBatchUpdates(updates, completion: {
    })
  }

  public var refreshAction: ((_ endRefreshing: @escaping ()->Void) -> Void)? = nil
  func setRefreshControl(_ control: UIRefreshControl) {
    listView?.refreshControl = control
    control.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
  }

  @objc func refresh(_ control: UIRefreshControl) {
    refreshAction?({
      control.endRefreshing()
    })
  }

}
