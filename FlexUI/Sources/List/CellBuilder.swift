//
//  CellBuilder.swift
//  YogaUI
//
//  Created by 黎昌明 on 2020/8/21.
//


public protocol CellBuildable: SectionBuildable {
  func buildCells() -> [Cell]
}

extension CellBuildable {

  public func buildSections() -> [Section] {
    return [Section(id: UniqueIdentifier()) { () -> Self in
      return self as Self
    }]
  }
}

extension Cell: CellBuildable {
  public func buildCells() -> [Cell] {
    return [self]
  }
}

extension ListViewAdapter {

  public func render<Cells>(@CellBuilder cells: () -> Cells ) where Cells: CellBuildable {
    render([
      Section(id: UniqueIdentifier(), cells: cells)
    ])
  }

}

extension Section {

  public init<Header: Node, Footer: Node, Cells: CellBuildable>(id: AnyHashable, header: Header, footer: Footer, @CellBuilder cells: () -> Cells) {
    self.id = id
    self.header = Cell(node: header)
    self.footer = Cell(node: footer)
    self.cells = cells().buildCells()
  }

  public init<Cells: CellBuildable>(id: AnyHashable, @CellBuilder cells: () -> Cells) {
    self.id = id
    self.header = nil
    self.footer = nil
    self.cells = cells().buildCells()
  }

  public init<Header: Node, Cells: CellBuildable>(id: AnyHashable, header: Header, @CellBuilder cells: () -> Cells) {
    self.id = id
    self.header = Cell(node: header)
    self.footer = nil
    self.cells = cells().buildCells()
  }

  public init<Footer: Node, Cells: CellBuildable>(id: AnyHashable, footer: Footer, @CellBuilder cells: () -> Cells) {
    self.id = id
    self.header = nil
    self.footer = Cell(node: footer)
    self.cells = cells().buildCells()
  }

}

@_functionBuilder
public struct CellBuilder: CellBuildable {

  private let cells: [Cell]

  private init(_ cells: [Cell]) {
    self.cells = cells
  }

  public func buildCells() -> [Cell] {
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
