//

//  Node.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/26.
//

public typealias FLNode = Node
public protocol Node: YogaTreeBuildable, Diffable, CellBuildable, SectionBuildable {
  associatedtype Body: Node
  var body: Body { get }
}

extension Node {
  public func build(with context: YogaTreeContext) -> [YogaNode] {
    body.build(with: context)
  }
}

public struct Never: Node {
  public typealias Body = Never
  
  public func build(with context: YogaTreeContext) -> [YogaNode] {
    fatalError()
  }
}

extension Node where Body == Never {
  public var body: Never {
    fatalError()
  }
}

