//
//  ListViewAdapter.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/31.
//

public final class ListViewAdapter: NSObject {

  static let StorageSectionHeaderIndex = -1
  static let StorageSectionFooterIndex = -2

  public internal(set) var data: [Section] = []
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

  public struct Registration: Hashable {
    public let id: String
    public let viewClass: AnyClass
    public init(id: String, viewClass: AnyClass) {
      self.id = id
      self.viewClass = viewClass
    }
    public static func == (lhs: ListViewAdapter.Registration, rhs: ListViewAdapter.Registration) -> Bool {
      return lhs.id == rhs.id && lhs.viewClass == rhs.viewClass
    }
    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
      hasher.combine(ObjectIdentifier(viewClass))
    }
  }
  // For CollectionView
  public var resigteredViews: Set<Registration> = .init()
  public weak var customLayoutInfo: AnyObject? = nil
  var customCellClass: AnyClass? = nil
  var customReusableViewClass: AnyClass? = nil
  var sectionHeaderKind: String = UICollectionView.elementKindSectionHeader
  var sectionFooterKind: String = UICollectionView.elementKindSectionFooter

  var staticLayoutStorage = [Int: [Int: FlexTree]]()
  var dynamicLayoutStorage = [AnyHashable: FlexTree]()
  var isStaticLayout = false

  public func itemCell(at indexPath: IndexPath) -> AnyNode {
    data[indexPath.section].cells[indexPath.item]
  }

  public func sectionHeader(at index: Int) -> AnyNode? {
    data[index].header
  }

  public func sectionFooter(at index: Int) -> AnyNode? {
    data[index].footer
  }

  public func treeForItem(at indexPath: IndexPath) -> FlexTree? {
    if isStaticLayout {
      return staticLayoutStorage[indexPath.section]?[indexPath.item]
    } else {
      return dynamicLayoutStorage[data[indexPath.section].cells[indexPath.item]]
    }
  }

  public func treeForHeader(at section: Int) -> FlexTree? {
    if isStaticLayout {
      return staticLayoutStorage[section]?[ListViewAdapter.StorageSectionHeaderIndex]
    } else {
      if let header =  data[section].header {
        return dynamicLayoutStorage[header]
      }
    }
    return nil
  }

  public func treeForFooter(at section: Int) -> FlexTree? {
    if isStaticLayout {
      return staticLayoutStorage[section]?[ListViewAdapter.StorageSectionFooterIndex]
    } else {
      if let footer =  data[section].footer {
        return dynamicLayoutStorage[footer]
      }
    }
    return nil
  }

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

  var infinateScrollAction: ((_ endRefreshing: @escaping (_ isAllLoaded: Bool) -> Void) -> Void)? = nil {
    didSet {
      listView?.infiniteScrollFooter.action = infinateScrollAction
    }
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
