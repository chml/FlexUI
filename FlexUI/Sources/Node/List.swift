//
//  List.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/27.
//

public struct List<View: ListView, Data, Element>: Node, ViewProducible {
  public typealias Body = Never
  public typealias ProductedView = View
  typealias ViewMaker = () -> View

  enum DataSource {
    case `static`(() -> SectionBuildable)
    case dynamicToCells(data: Data, builder: (Element) -> CellBuildable, adapter:(Data, (Element)->CellBuildable)->SectionBuildable)
    case dynamicToSections(data: Data, builder: (Element) -> Section, adapter: (Data, (Element)-> Section)->SectionBuildable)
  }
  let dataSource: DataSource
  let viewMaker: ViewMaker?

  enum Modifier {
    case onSelect(action: (AnyNode, IndexPath) -> Void)
    case pullToRefresh(action: (_ endRefreshing: @escaping () -> Void) -> Void)
    case infiniteScroll(action: (_ endRefreshing: @escaping (_ isAllLoaded: Bool) -> Void) -> Void)
    case reversed(Bool)
    case alwaysReload(Bool)
    case customLayoutInfo(AnyObject)
    case customCellClass(AnyClass)
    case customReusableViewClass(AnyClass)
    case sectionHeaerKind(String)
    case sectionFooterKind(String)
  }
  let modifiers: [Modifier]

  init(of type: View.Type, dataSource: DataSource, modifiers: [Modifier] = [], viewMaker: ViewMaker? ) {
    self.dataSource = dataSource
    self.modifiers = modifiers
    self.viewMaker = viewMaker
  }

}


extension List where Data: Collection, Element == Data.Element {

  init(of type: View.Type, maker: @escaping ViewMaker, data: Data, sectionBuilder: @escaping (Element) -> Section) {
    self.init(of: type, dataSource: .dynamicToSections(data: data, builder: sectionBuilder, adapter:{ (data, builder) in
      return data.map{ builder($0) } as SectionBuildable
    }), viewMaker: maker)
  }

  init(of type: View.Type, maker: @escaping ViewMaker, data: Data, @CellBuilder cellBuilder: @escaping (Element) -> CellBuildable) {
    self.init(of: type, dataSource: .dynamicToCells(data: data, builder: cellBuilder, adapter: { (data, builder) -> SectionBuildable in
      return Section(id: UniqueIdentifier(), cells: data.map { builder($0).buildCells() }.flatMap { $0 })
    }), viewMaker: maker)
  }
}

extension List where Data == Void, Element == Void {

  init(of type: View.Type, maker: @escaping ViewMaker, @SectionBuilder sectionBuilder: @escaping () -> SectionBuildable) {
    self.init(of: type, dataSource: .static(sectionBuilder), viewMaker: maker)
  }

  init(of type: View.Type, maker: @escaping ViewMaker, @CellBuilder cellBuilder: @escaping () -> CellBuildable) {
    self.init(of: type, dataSource: .static({ () -> SectionBuildable in
      Section(id: UniqueIdentifier(), header: nil, footer: nil, cells: cellBuilder().buildCells())
    }), viewMaker: maker)
  }

}

import class UIKit.UITableView
import class UIKit.UICollectionView
import class UIKit.UICollectionViewLayout

extension List where View: UITableView, Data: Collection, Element == Data.Element {

  public init(data: Data, sectionBuilder: @escaping (Element) -> Section) {
    self.init(table: .plain, data: data, sectionBuilder: sectionBuilder)
  }

  public init(table style: View.Style, data: Data, sectionBuilder: @escaping (Element) -> Section) {
    self.init(of: View.self, maker: { View(frame: .zero, style: style) }, data: data, sectionBuilder:sectionBuilder)
  }

  public init(data: Data, @CellBuilder cellBuilder: @escaping (Element) -> CellBuildable) {
    self.init(table: .plain, data: data, cellBuilder: cellBuilder)
  }

  public init(table style: View.Style, data: Data, @CellBuilder cellBuilder: @escaping (Element) -> CellBuildable) {
    self.init(of: View.self, maker: { View(frame: .zero, style: style) }, data: data, cellBuilder: cellBuilder)
  }
}

extension List where View: UICollectionView, Data: Collection, Element == Data.Element {

  public init(collection layout: UICollectionViewLayout, data: Data, sectionBuilder: @escaping (Element) -> Section) {
    self.init(of: View.self, maker: { View(frame: .zero, collectionViewLayout: layout) }, data: data, sectionBuilder:sectionBuilder)
  }

  public init(collection layout: UICollectionViewLayout, data: Data, @CellBuilder cellBuilder: @escaping (Element) -> CellBuildable) {
    self.init(of: View.self, maker: { View(frame: .zero, collectionViewLayout: layout) }, data: data, cellBuilder: cellBuilder)
  }
}


extension List where View: UITableView, Data == Void, Element == Void {

  public init(@SectionBuilder sectionBuilder: @escaping () -> SectionBuildable) {
    self.init(table: .plain, sectionBuilder: sectionBuilder)
  }

  public init(table style: View.Style, @SectionBuilder sectionBuilder: @escaping () -> SectionBuildable) {
    self.init(of: View.self, maker: { View(frame: .zero, style: style) }, sectionBuilder: sectionBuilder)
  }

  public init(@CellBuilder cellBuilder: @escaping () -> CellBuildable) {
    self.init(table: .plain, cellBuilder: cellBuilder)
  }

  public init(table style: View.Style, @CellBuilder cellBuilder: @escaping () -> CellBuildable) {
    self.init(of: View.self, maker: { View(frame: .zero, style: style) }, cellBuilder: cellBuilder)
  }

}

extension List where View: UICollectionView, Data == Void, Element == Void {

  public init(collection layout: UICollectionViewLayout, @SectionBuilder sectionBuilder: @escaping () -> SectionBuildable) {
    self.init(of: View.self, maker: { View(frame: .zero, collectionViewLayout: layout) }, sectionBuilder: sectionBuilder)
  }

  public init(collection layout: UICollectionViewLayout, @CellBuilder cellBuilder: @escaping () -> CellBuildable) {
    self.init(of: View.self, maker: { View(frame: .zero, collectionViewLayout: layout) }, cellBuilder: cellBuilder)
  }

}


extension List {

  private func list(with modifier: Modifier) -> Self {
    var modifiers = self.modifiers
    modifiers.append(modifier)
    return List(of: View.self, dataSource: dataSource, modifiers: modifiers, viewMaker: viewMaker)
  }

  public func pullToRefresh(_ action: @escaping (_ endRefreshing: @escaping () -> Void) -> Void) -> Self {
    return list(with: .pullToRefresh(action: action))
  }

  public func infiniteScroll(_ action: @escaping (_ endRefreshing: @escaping (_ isAllLoaded: Bool) -> Void) -> Void) -> Self {
    return list(with: .infiniteScroll(action: action))
  }

  public func onSelect(_ action: @escaping (AnyNode, IndexPath) -> Void) -> Self {
    return list(with: .onSelect(action: action))
  }

  public func onSelect(_ action: @escaping (AnyNode) -> Void) -> Self {
    return list(with: .onSelect(action: { (node, _) in
      action(node)
    }))
  }

  public func reversed(_ reversed: Bool) -> Self {
    return list(with: .reversed(reversed))
  }

  public func alwaysReload(_ reload: Bool) -> Self {
    return list(with: .alwaysReload(reload))
  }

  public func customLayoutInfo(_ info: AnyObject) -> Self {
    return list(with: .customLayoutInfo(info))
  }

  public func customCellClass(_ cls: AnyClass) -> Self {
    return list(with: .customCellClass(cls))
  }

  public func customReusableViewClass(_ cls: AnyClass) -> Self {
    return list(with: .customReusableViewClass(cls))
  }

  public func sectionHeaderKind(_ kind: String) -> Self {
    return list(with: .sectionHeaerKind(kind))
  }

  public func sectionFooterKind(_ kind: String) -> Self {
    return list(with: .sectionFooterKind(kind))
  }
}

extension List {

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let yogaNode = FlexNode()
    let viewProducer = ViewProducer(type: View.self)
    if let maker = viewMaker {
      viewProducer.viewMaker = {
        maker()
      }
    }
    yogaNode.viewProducer = viewProducer
    configureListView(with: viewProducer)
    return [yogaNode]
  }

  private func configureListView(with provider: ViewProducer) {
    provider.appendDeferConfiguration(as: ProductedView.self) { view in
      if view.listAdapter == nil {
        ListViewAdapter().listView = view
      }
      guard let adapter = view.listAdapter else {
        return
      }
      switch self.dataSource {
      case .static(let builder):
        adapter.render(sections: builder)
      case .dynamicToCells(let data, let builder, let mapper):
        adapter.render {
          mapper(data, builder)
        }
      case .dynamicToSections(let data, let builder, let mapper):
        adapter.render {
          mapper(data, builder)
        }
      }

      for modifier in self.modifiers {
        switch modifier {
        case .onSelect(let action):
          adapter.onSelect = action
        case .pullToRefresh(let action):
          adapter.setRefreshControl(UIRefreshControl())
          adapter.refreshAction = action
        case .infiniteScroll(let action):
          adapter.infinateScrollAction = action
        case .reversed(let reversed):
          adapter.reversed = reversed
        case .alwaysReload(let reload):
          adapter.updater.alwaysReload = reload
        case .customLayoutInfo(let info):
          adapter.customLayoutInfo = info
        case .customCellClass(let cls):
          adapter.customCellClass = cls
        case .customReusableViewClass(let cls):
          adapter.customReusableViewClass = cls
        case .sectionHeaerKind(let kind):
          adapter.sectionHeaderKind = kind
        case .sectionFooterKind(let kind):
          adapter.sectionFooterKind = kind
        } // switch modifier
      } // for modifier
    }
  }

}
