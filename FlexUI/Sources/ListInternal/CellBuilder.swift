//
//  CellBuilder.swift
//  YogaUI
//
//  Created by Li ChangMing on 2020/8/21.
//


public protocol CellBuildable {
  func buildCells() -> [AnyNode]
}


extension ListViewAdapter {
  public func render<Cells>(@CellBuilder cellsBuilder: () -> Cells ) where Cells: CellBuildable {
    render([
      Section(id: UniqueIdentifier(), cellsBuilder: cellsBuilder)
    ])
  }
}

extension Array: CellBuildable where Element: CellBuildable {
  public func buildCells() -> [AnyNode] {
    map { $0.buildCells() }.flatMap { $0 }
  }
}

extension Section {

  public init<Header: Node, Footer: Node, Cells: CellBuildable>(id: AnyHashable, header: Header, footer: Footer, @CellBuilder cellsBuilder: () -> Cells) {
    self.id = id
    self.header = AnyNode(header)
    self.footer = AnyNode(footer)
    self.cells = cellsBuilder().buildCells()
  }

  public init<Cells: CellBuildable>(id: AnyHashable, @CellBuilder cellsBuilder: () -> Cells) {
    self.id = id
    self.header = nil
    self.footer = nil
    self.cells = cellsBuilder().buildCells()
  }

  public init<Header: Node, Cells: CellBuildable>(id: AnyHashable, header: Header, @CellBuilder cellsBuilder: () -> Cells) {
    self.id = id
    self.header = AnyNode(header)
    self.footer = nil
    self.cells = cellsBuilder().buildCells()
  }

  public init<Footer: Node, Cells: CellBuildable>(id: AnyHashable, footer: Footer, @CellBuilder cellsBuilder: () -> Cells) {
    self.id = id
    self.header = nil
    self.footer = AnyNode(footer)
    self.cells = cellsBuilder().buildCells()
  }

}

@_functionBuilder
public struct CellBuilder: CellBuildable {

  private let cells: [AnyNode]

  init(_ cells: [AnyNode]) {
    self.cells = cells
  }

  public func buildCells() -> [AnyNode] {
    return cells
  }

  public static func buildBlock() -> CellBuilder {
    return CellBuilder([])
  }

  public static func buildBlock<Content: CellBuildable>(_ content: Content) -> Content {
    return content
  }

  public static func buildBlock<Content: CellBuildable>(_ content: Content?) -> CellBuildable {
    guard let content = content else {
      return CellBuilder([])
    }
    return content
  }

  public static func buildBlock<C: Collection>(_ content: C) -> CellBuildable where C.Element: CellBuildable{
    return CellBuilder(content.map { $0.buildCells() }.flatMap { $0 })
  }

  public static func buildBlock(_ content: CellBuildable...) -> CellBuilder {
    return CellBuilder(content.flatMap { $0.buildCells() })
  }

  public static func buildBlock(_ content: CellBuildable?...) -> CellBuilder {
    return CellBuilder(content.compactMap { $0 }.flatMap { $0.buildCells() })
  }

  public static func buildBlock<C: Collection>(_ contents: C) -> CellBuilder where C.Element: CellBuildable {
    return CellBuilder(contents.flatMap { $0.buildCells() })
  }

  public static func buildIf<Content: CellBuildable>(_ content: Content) -> Content  {
    return content
  }

  public static func buildIf<Content: CellBuildable>(_ content: Content?) -> Content? {
    return content
  }

  public static func buildEither<TrueContent: CellBuildable>(first: TrueContent) -> CellBuilder {
    return CellBuilder(first.buildCells())
  }

  public static func buildEither<FalseContent: CellBuildable>(second: FalseContent) -> CellBuilder {
    return CellBuilder(second.buildCells())
  }


}
