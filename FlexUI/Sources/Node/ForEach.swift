//
//  ForEach.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/3.
//


public struct ForEach<Data: RandomAccessCollection, Content> {

  let data: Data
  let content: (Data.Element) -> Content

}

extension ForEach: Node, CellBuildable, Diffable, YogaTreeBuildable where Content: Node {

  public typealias Body = Never

  public init(_ data: Data, @NodeBuilder content: @escaping (Data.Element) -> Content) {
    self.data = data
    self.content = content
  }

  public init(_ data: Data, @NodeBuilder content: @escaping () -> Content) {
    self.data = data
    self.content = { _ in
      content()
    }
  }
  
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    data.map { (elem) -> [FlexNode] in
      content(elem).build(with: context)
    }
    .flatMap { $0 }
  }

  public func buildCells() -> [AnyNode] {
    data.map { (elem) -> AnyNode in
      AnyNode(content(elem))
    }
  }

  public var id: AnyHashable {
    return String(describing: type(of: self))
  }

  public func isContentEqual(to other: Self) -> Bool {
    return false
  }
}

extension ForEach: SectionBuildable where Content == Section {

  public init(_ data: Data, content: @escaping (Data.Element) -> Content) {
    self.data = data
    self.content = content
  }
  
  public init(_ data: Data, @NodeBuilder content: @escaping () -> Content) {
    self.data = data
    self.content = { _ in
      content()
    }
  }

  public func buildSections() -> [Section] {
    data.map { (elem) -> [Section] in
      content(elem).buildSections()
    }
    .flatMap { $0 }
  }

}

