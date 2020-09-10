//
//  ListViewAdapter.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/31.
//

public final class ListViewAdapter: NSObject {

  static let StorageSectionHeaderIndex = -1
  static let StorageSectionFooterIndex = -2

  var data: [Section] = []
  var onSelect: ((AnyNode, IndexPath) -> Void)? = nil
  var autoDeselect: Bool = true
  lazy var updater: ListViewUpdater = ListViewUpdater()

  struct Registration: Hashable {
    let id: String
    let viewClass: AnyClass
    static func == (lhs: ListViewAdapter.Registration, rhs: ListViewAdapter.Registration) -> Bool {
      return lhs.id == rhs.id && lhs.viewClass == lhs.viewClass
    }
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
      hasher.combine(ObjectIdentifier(viewClass))
    }
  }
  var resigteredViews: Set<Registration> = .init()

  var staticLayoutStorage = [Int: [Int: FlexTree]]()
  var dynamicLayoutStorage = [AnyHashable: FlexTree]()
  var isStaticLayout = false

  weak var listView: ListView? {
    didSet {
      if let listView = listView {
        updater.prepare(for: listView, adapter: self)
      }
    }
  }

  func render<C: Collection>(_ data: C) where C.Element == Section {
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

  var refreshAction: ((_ endRefreshing: @escaping ()->Void) -> Void)? = nil
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
