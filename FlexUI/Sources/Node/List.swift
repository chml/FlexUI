//
//  List.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/27.
//



public struct List<View: ListView, Data, Element>: Node, ViewProducible {
  public typealias Body = Never
  public typealias ProductedView = View

  enum DataSource {
    case `static`(() -> SectionBuildable)
    case dynamicToCells(data: Data, builder: (Element) -> CellBuildable, adapter:(Data, (Element)->CellBuildable)->SectionBuildable)
    case dynamicToSections(data: Data, builder: (Element) -> Section, adapter: (Data, (Element)-> Section)->SectionBuildable)
  }
  let dataSource: DataSource

  enum Modifier {
    case onSelect(action: (AnyNode, IndexPath) -> Void)
    case pullToRefresh(action: (_ endRefreshing: @escaping () -> Void) -> Void)
    case infiniteScroll(action: (_ endRefreshing: @escaping () -> Void) -> Void)
  }
  let modifiers: [Modifier]

  init(of type: View.Type, dataSource: DataSource, modifiers: [Modifier] = []) {
    self.dataSource = dataSource
    self.modifiers = modifiers
  }

}

extension List where Data: Collection, Element == Data.Element {

  public init(of type: View.Type, data: Data, sectionBuilder: @escaping (Element) -> Section) {
    self.init(of: type, dataSource: .dynamicToSections(data: data, builder: sectionBuilder, adapter:{ (data, builder) in
      return data.map{ builder($0) } as SectionBuildable
    }))
  }

  public init(of type: View.Type, data: Data, @CellBuilder cellBuilder: @escaping (Element) -> CellBuildable) {
    self.init(of: type, dataSource: .dynamicToCells(data: data, builder: cellBuilder, adapter: { (data, builder) -> SectionBuildable in
      return Section(id: UniqueIdentifier(), cells: data.map { builder($0).buildCells() }.flatMap { $0 })
    }))
  }

}

extension List where Data == Void, Element == Void {

  public init(of type: View.Type, @SectionBuilder sectionBuilder: @escaping () -> SectionBuildable) {
    self.init(of: type, dataSource: .static(sectionBuilder))
  }

  public init(of type: View.Type, @CellBuilder cellBuilder: @escaping () -> CellBuildable) {
    self.init(of: type, dataSource: .static({ () -> SectionBuildable in
      Section(id: UniqueIdentifier(), header: nil, footer: nil, cells: cellBuilder().buildCells())
    }))
  }

}


extension List {

  private func list(with modifier: Modifier) -> Self {
    var modifiers = self.modifiers
    modifiers.append(modifier)
    return List(of: View.self, dataSource: dataSource, modifiers: modifiers)
  }

  public func pullToRefresh(_ action: @escaping (_ endRefreshing: @escaping () -> Void) -> Void) -> Self {
    return list(with: .pullToRefresh(action: action))
  }

  public func infiniteScroll(_ action: @escaping (_ endRefreshing: @escaping () -> Void) -> Void) -> Self {
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

}

extension List {

  public func build(with context: YogaTreeContext) -> [YogaNode] {
    let yogaNode = YogaNode()
    let viewProducer = ViewProducer(type: View.self)
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
      default: break
      }

      for modifier in self.modifiers {
        switch modifier {
        case .onSelect(let action):
          adapter.onSelect = action
        case .pullToRefresh(let action):
          adapter.setRefreshControl(UIRefreshControl())
          adapter.refreshAction = action
        case .infiniteScroll(let action): break
        } // switch modifier
      } // for modifier
    }
  }

}
