//
//  View.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/27.
//


public struct View<T: UIView, Children: Node>: Node, ViewProducible {
  public typealias ProductedView = T
  public var body = Never()
  let children: Children
  public init(of _: T.Type, @NodeBuilder _ builder: () -> Children) {
    self.children = builder()
  }
}

extension View where T == UIView {
  public init(@NodeBuilder _ builder: () -> Children) {
    self.init(of: T.self, builder)
  }
}

extension View where Children == EmptyNode {
  public init(of type: T.Type) {
    self.init(of: type) {
      EmptyNode()
    }
  }
}

extension View where T == UIView, Children == EmptyNode {
  public init() {
    self.init(of: T.self) {
      EmptyNode()
    }
  }
}

extension View {

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let node = FlexNode()
    let viewProducer = ViewProducer(type: T.self)
    node.viewProducer = viewProducer
    children.build(with: context.with(parent: node)).forEach { (n) in
      node.insertChild(n)
    }
    return [node]
  }

}
