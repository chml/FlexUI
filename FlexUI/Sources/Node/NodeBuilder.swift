//
//  NodeBuilder.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/26.
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

  public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleNode1<C0, C1> where C0: Node, C1: Node {
      return .init(c0, c1)
  }

  public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleNode2<C0, C1, C2> where C0: Node, C1: Node, C2: Node {
      return .init(c0, c1, c2)
  }

  public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleNode3<C0, C1, C2, C3> where C0: Node, C1: Node, C2: Node, C3: Node {
      return .init(c0, c1, c2, c3)
  }

  public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleNode4<C0, C1, C2, C3, C4> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node {
      return .init(c0, c1, c2, c3, c4)
  }

  public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleNode5<C0, C1, C2, C3, C4, C5> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node, C5: Node {
      return .init(c0, c1, c2, c3, c4, c5)
  }

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleNode6<C0, C1, C2, C3, C4, C5, C6> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node, C5: Node, C6: Node {
      return .init(c0, c1, c2, c3, c4, c5, c6)
  }

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleNode7<C0, C1, C2, C3, C4, C5, C6, C7> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node, C5: Node, C6: Node, C7: Node {
      return .init(c0, c1, c2, c3, c4, c5, c6, c7)
  }

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleNode8<C0, C1, C2, C3, C4, C5, C6, C7, C8> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node, C5: Node, C6: Node, C7: Node, C8: Node {
      return .init(c0, c1, c2, c3, c4, c5, c6, c7, c8)
  }

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleNode9<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9> where C0: Node, C1: Node, C2: Node, C3: Node, C4: Node, C5: Node, C6: Node, C7: Node, C8: Node, C9: Node {
      return .init(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
  }
  
}


public struct EmptyNode: Node {
  public typealias Body = Never
  public init() {}
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    return []
  }
}

public struct OptionalNode<T: Node>: Node {
  public typealias Body = Never
  let node: T?
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    return node?.build(with: context) ?? []
  }
}

public struct TupleNode1<T0: Node, T1: Node>: Node {
  public typealias Body = Never
  public let v0: T0
  public let v1: T1

  public init(_ v0: T0, _ v1: T1) {
    self.v0 = v0
    self.v1 = v1
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    [ v0.build(with: context),
      v1.build(with: context) ].flatMap { $0 }
  }
}

public struct TupleNode2<T0: Node, T1: Node, T2: Node>: Node {
  public typealias Body = Never
  public let v0: T0
  public let v1: T1
  public let v2: T2

  public init(_ v0: T0, _ v1: T1, _ v2: T2) {
    self.v0 = v0
    self.v1 = v1
    self.v2 = v2
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    [ v0.build(with: context),
      v1.build(with: context),
      v2.build(with: context),
      ].flatMap { $0 }
  }
}

public struct TupleNode3<T0: Node, T1: Node, T2: Node, T3: Node>: Node {
  public typealias Body = Never
  public let v0: T0
  public let v1: T1
  public let v2: T2
  public let v3: T3

  public init(_ v0: T0, _ v1: T1, _ v2: T2, _ v3: T3) {
    self.v0 = v0
    self.v1 = v1
    self.v2 = v2
    self.v3 = v3
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    [ v0.build(with: context),
      v1.build(with: context),
      v2.build(with: context),
      v3.build(with: context),
      ].flatMap { $0 }
  }
}

public struct TupleNode4<T0: Node, T1: Node, T2: Node, T3: Node, T4: Node>: Node {
  public typealias Body = Never
  public let v0: T0
  public let v1: T1
  public let v2: T2
  public let v3: T3
  public let v4: T4

  public init(_ v0: T0, _ v1: T1, _ v2: T2, _ v3: T3,
              _ v4: T4) {
    self.v0 = v0
    self.v1 = v1
    self.v2 = v2
    self.v3 = v3
    self.v4 = v4
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    [ v0.build(with: context),
      v1.build(with: context),
      v2.build(with: context),
      v3.build(with: context),
      v4.build(with: context),
      ].flatMap { $0 }
  }
}

public struct TupleNode5<T0: Node, T1: Node, T2: Node, T3: Node, T4: Node, T5: Node>: Node {
  public typealias Body = Never
  public let v0: T0
  public let v1: T1
  public let v2: T2
  public let v3: T3
  public let v4: T4
  public let v5: T5

  public init(_ v0: T0, _ v1: T1, _ v2: T2, _ v3: T3,
              _ v4: T4, _ v5: T5) {
    self.v0 = v0
    self.v1 = v1
    self.v2 = v2
    self.v3 = v3
    self.v4 = v4
    self.v5 = v5
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    [ v0.build(with: context),
      v1.build(with: context),
      v2.build(with: context),
      v3.build(with: context),
      v4.build(with: context),
      v5.build(with: context),
      ].flatMap { $0 }
  }
}

public struct TupleNode6<T0: Node, T1: Node, T2: Node, T3: Node, T4: Node, T5: Node, T6: Node>: Node {
  public typealias Body = Never
  public let v0: T0
  public let v1: T1
  public let v2: T2
  public let v3: T3
  public let v4: T4
  public let v5: T5
  public let v6: T6

  public init(_ v0: T0, _ v1: T1, _ v2: T2, _ v3: T3,
              _ v4: T4, _ v5: T5, _ v6: T6) {
    self.v0 = v0
    self.v1 = v1
    self.v2 = v2
    self.v3 = v3
    self.v4 = v4
    self.v5 = v5
    self.v6 = v6
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    [ v0.build(with: context),
      v1.build(with: context),
      v2.build(with: context),
      v3.build(with: context),
      v4.build(with: context),
      v5.build(with: context),
      v6.build(with: context),
      ].flatMap { $0 }
  }
}

public struct TupleNode7<T0: Node, T1: Node, T2: Node, T3: Node, T4: Node, T5: Node, T6: Node, T7: Node>: Node {
  public typealias Body = Never
  public let v0: T0
  public let v1: T1
  public let v2: T2
  public let v3: T3
  public let v4: T4
  public let v5: T5
  public let v6: T6
  public let v7: T7

  public init(_ v0: T0, _ v1: T1, _ v2: T2, _ v3: T3,
              _ v4: T4, _ v5: T5, _ v6: T6, _ v7: T7) {
    self.v0 = v0
    self.v1 = v1
    self.v2 = v2
    self.v3 = v3
    self.v4 = v4
    self.v5 = v5
    self.v6 = v6
    self.v7 = v7
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    [ v0.build(with: context),
      v1.build(with: context),
      v2.build(with: context),
      v3.build(with: context),
      v4.build(with: context),
      v5.build(with: context),
      v6.build(with: context),
      v7.build(with: context),
      ].flatMap { $0 }
  }
}

public struct TupleNode8<T0: Node, T1: Node, T2: Node, T3: Node, T4: Node, T5: Node, T6: Node, T7: Node, T8: Node>: Node {
  public typealias Body = Never
  public let v0: T0
  public let v1: T1
  public let v2: T2
  public let v3: T3
  public let v4: T4
  public let v5: T5
  public let v6: T6
  public let v7: T7
  public let v8: T8

  public init(_ v0: T0, _ v1: T1, _ v2: T2, _ v3: T3,
              _ v4: T4, _ v5: T5, _ v6: T6, _ v7: T7,
              _ v8: T8) {
    self.v0 = v0
    self.v1 = v1
    self.v2 = v2
    self.v3 = v3
    self.v4 = v4
    self.v5 = v5
    self.v6 = v6
    self.v7 = v7
    self.v8 = v8
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    [ v0.build(with: context),
      v1.build(with: context),
      v2.build(with: context),
      v3.build(with: context),
      v4.build(with: context),
      v5.build(with: context),
      v6.build(with: context),
      v7.build(with: context),
      v8.build(with: context),
      ].flatMap { $0 }
  }
}

public struct TupleNode9<T0: Node, T1: Node, T2: Node, T3: Node, T4: Node, T5: Node, T6: Node, T7: Node, T8: Node, T9: Node>: Node {
  public typealias Body = Never
  public let v0: T0
  public let v1: T1
  public let v2: T2
  public let v3: T3
  public let v4: T4
  public let v5: T5
  public let v6: T6
  public let v7: T7
  public let v8: T8
  public let v9: T9

  public init(_ v0: T0, _ v1: T1, _ v2: T2, _ v3: T3,
              _ v4: T4, _ v5: T5, _ v6: T6, _ v7: T7,
              _ v8: T8, _ v9: T9) {
    self.v0 = v0
    self.v1 = v1
    self.v2 = v2
    self.v3 = v3
    self.v4 = v4
    self.v5 = v5
    self.v6 = v6
    self.v7 = v7
    self.v8 = v8
    self.v9 = v9
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    [ v0.build(with: context),
      v1.build(with: context),
      v2.build(with: context),
      v3.build(with: context),
      v4.build(with: context),
      v5.build(with: context),
      v6.build(with: context),
      v7.build(with: context),
      v8.build(with: context),
      v9.build(with: context),
      ].flatMap { $0 }
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

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    switch self.storage {
    case .trueContent(let content): return content.build(with: context)
    case .falseContent(let content): return content.build(with: context)
    }
  }
}

