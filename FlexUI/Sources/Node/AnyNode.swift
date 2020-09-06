//
//  AnyNode.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/27.
//


public struct AnyNode: Node {
  public typealias Body = Never
  fileprivate let base: Any
  fileprivate let build: (FlexTreeContext) -> [FlexNode]
  let isEqualTo: (AnyNode) -> Bool
  public let typeName: String
  public let id: AnyHashable

  public init<T: Node>(_ baseNode: T) {
    self.id = baseNode.id
    self.base = baseNode
    self.typeName = String(describing: type(of: baseNode))
    self.isEqualTo = { (other) -> Bool in
      if let otherBase = other.base as? T {
        return baseNode.isContentEqual(to: otherBase)
      }
      return false
    }
    build = { (context) -> [FlexNode] in
      baseNode.build(with: context)
    }
  }

  public func unwrap<T>(as _: T.Type) -> T? {
    return base as? T
  }


}

extension AnyNode {
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    build(context)
  }
}

