//
//  NodeBuilder.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/26.
//

//import Mirror

@_functionBuilder
public struct NodeBuilder {

  public static func buildBlock() -> EmptyNode {
    return EmptyNode()
  }

  public static func buildBlock<Content: Node>(_ content: Content) -> Content {
    return content
  }

  public static func buildBlock<Content: Node>(_ content: Content?) -> OptionalNode<Content> {
    return OptionalNode(node: content)
  }

  public static func buildIf<Content: Node>(_ content: Content) -> Content {
    return content
  }

  public static func buildIf<Content: Node>(_ content: Content?) -> OptionalNode<Content> {
    return OptionalNode(node: content)
  }

  public static func buildEither<True: Node, False: Node>(first: True) -> _ConditionalContent<True, False> {
    return .init(storage: .trueContent(first))
  }

  public static func buildEither<True: Node, False: Node>(second: False) -> _ConditionalContent<True, False> {
    return .init(storage: .falseContent(second))
  }

  public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleNode<(C0, C1)> where C0: Node, C1: Node {
      return .init((c0, c1))
  }

  public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleNode<(C0, C1, C2)> where C0: Node, C1: Node, C2: Node {
      return .init((c0, c1, c2))
  }

  public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleNode<(C0, C1, C2, C3)> where C0: Node, C1: Node, C2: Node, C3: Node {
      return .init((c0, c1, c2, c3))
  }

  public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleNode<(C0, C1, C2, C3, C4)> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node {
      return .init((c0, c1, c2, c3, c4))
  }

  public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleNode<(C0, C1, C2, C3, C4, C5)> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node, C5: Node {
      return .init((c0, c1, c2, c3, c4, c5))
  }

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleNode<(C0, C1, C2, C3, C4, C5, C6)> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node, C5: Node, C6: Node {
      return .init((c0, c1, c2, c3, c4, c5, c6))
  }

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleNode<(C0, C1, C2, C3, C4, C5, C6, C7)> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node, C5: Node, C6: Node, C7: Node {
      return .init((c0, c1, c2, c3, c4, c5, c6, c7))
  }

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleNode<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node, C5: Node, C6: Node, C7: Node, C8: Node {
      return .init((c0, c1, c2, c3, c4, c5, c6, c7, c8))
  }

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleNode<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node, C5: Node, C6: Node, C7: Node, C8: Node, C9: Node {
      return .init((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
  }
  
}


public struct EmptyNode: Node {
  public typealias Body = Never

  public func build(with context: YogaTreeContext) -> [YogaNode] {
    return []
  }
}

public struct OptionalNode<T: Node>: Node {
  public typealias Body = Never
  let node: T?
  public func build(with context: YogaTreeContext) -> [YogaNode] {
    return node?.build(with: context) ?? []
  }
}

public struct TupleNode<T>: Node {
  public typealias Body = Never
  public var value: T

  public init(_ value: T) {
    self.value = value
  }

  public func build(with context: YogaTreeContext) -> [YogaNode] {
    let mirror = Mirror(reflecting: value)
    return mirror.children.map { (child) -> [YogaNode] in
      if let childNode = child.value as? YogaTreeBuildable {
        return childNode.build(with: context)
      }
      return []
    }
    .flatMap { $0 }
  }
}

public struct _ConditionalContent<True, False>: Node where True: Node, False: Node {
  public enum Storage {
    case trueContent(True)
    case falseContent(False)
  }

  public typealias Body = Never
  let storage: Storage

  init(storage: Storage) {
    self.storage = storage
  }

  public func build(with context: YogaTreeContext) -> [YogaNode] {
    switch self.storage {
    case .trueContent(let content): return content.build(with: context)
    case .falseContent(let content): return content.build(with: context)
    }
  }
}

