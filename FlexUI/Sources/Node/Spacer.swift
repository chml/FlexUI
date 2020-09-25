//
//  Spacer.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/25.
//


public struct Spacer: Node {
  public typealias Body = Never
  let grow: CGFloat
  let shrink: CGFloat
  public init(grow: CGFloat = 1, shrink: CGFloat = 1) {
    self.grow = grow
    self.shrink = shrink
  }
}

extension Spacer {
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let flexNode = FlexNode()
    flexNode.style.flexGrow = grow
    flexNode.style.flexShrink = shrink
    return [flexNode]
  }
}
