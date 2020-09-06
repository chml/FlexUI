//

//  Node.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/26.
//

public typealias FLNode = Node
public protocol Node: YogaTreeBuildable, Diffable, CellBuildable {
  associatedtype Body: Node
  var body: Body { get }

  var isComponent: Bool { get }
}

extension Node {
  public var isComponent: Bool { false }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    body.build(with: context)
  }
}

public struct Never: Node {
  public typealias Body = Never
  
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    fatalError()
  }
}

extension Node where Body == Never {
  public var body: Never {
    fatalError()
  }
}

