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
  lazy var updater: ListViewUpdater = ListViewUpdater()
  var onSelect: ((AnyNode, IndexPath) -> Void)? = nil
  var autoDeselect: Bool = true
  var reversed: Bool = false {
    didSet {
      listView?.transform = CGAffineTransform(scaleX: 1, y: reversed ? -1 : 1)
      if let scrollView = listView as? UIScrollView {
        scrollView.scrollIndicatorInsets = reversed ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: scrollView.bounds.size.width - 8) : .zero
      }
      listView?.reloadData()
    }
  }

  struct Registration: Hashable {
    let id: String
    let viewClass: AnyClass
    static func == (lhs: ListViewAdapter.Registration, rhs: ListViewAdapter.Registration) -> Bool {
      return lhs.id == rhs.id && lhs.viewClass == rhs.viewClass
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

extension AnyNode: Hashable {

  public static func == (lhs: AnyNode, rhs: AnyNode) -> Bool {
    return lhs.isContentEqual(to: rhs)
  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }

}
