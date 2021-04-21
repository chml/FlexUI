//
//  ModifiedContent.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/28.
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

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    return modifier.build(node: content, with: context)
  }
}


extension ModifiedContent: Equatable where Content: Equatable, Modifier: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.content == rhs.content && lhs.modifier == lhs.modifier
  }
}

extension ModifiedContent: Hashable where Content: Hashable, Modifier: Hashable {

  public var id: AnyHashable {
    return self
  }

  public func isContentEqual(to other: ModifiedContent<Content, Modifier>) -> Bool {
    return self == other
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(content)
    hasher.combine(modifier)
  }
}

