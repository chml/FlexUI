//
//  NodeModifier.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/27.
//

public protocol NodeModifier {
  func build<T: Node>(node: T, with context: YogaTreeContext) -> [YogaNode]
}

extension NodeModifier {
  public func build<T: Node>(node: T, with context: YogaTreeContext) -> [YogaNode] {
    return node.build(with: context)
  }
}

extension Node {

  @inlinable
  public func modifier<T: NodeModifier>(_ modifier: T) -> ModifiedContent<Self, T> {
    return ModifiedContent(content: self, modifier: modifier)
  }

}
