//
//  ModifiedContent.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/28.
//

public struct ModifiedContent<Content: Node, Modifier: NodeModifier>: Node {
  public let content: Content
  public let modifier: Modifier
  public init(content: Content, modifier: Modifier) {
    self.content = content
    self.modifier = modifier
  }
}


extension ModifiedContent {
  public typealias Body = Never

  public func build(with context: YogaTreeContext) -> [YogaNode] {
    return modifier.build(node: content, with: context)
  }
}


