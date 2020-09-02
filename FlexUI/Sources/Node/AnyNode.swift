//
//  AnyNode.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/27.
//


public struct AnyNode: Node {
  public typealias Body = Never
  fileprivate let base: Any
  fileprivate let build: (YogaTreeContext) -> [YogaNode]
  fileprivate let isEqualTo: (AnyNode) -> Bool
  public let id: AnyHashable

  public init<T: Node>(_ baseNode: T) {
    self.id = baseNode.id
    self.base = baseNode
    self.isEqualTo = { (other) -> Bool in
      if let otherBase = other.base as? T {
        return baseNode.isContentEqual(to: otherBase)
      }
      return false
    }
    build = { (context) -> [YogaNode] in
      baseNode.build(with: context)
    }
  }

  public func unwrap<T>(as _: T.Type) -> T? {
    return base as? T
  }

  public func isContentEqual(to other: AnyNode) -> Bool {
    return isEqualTo(other)
  }

}

extension AnyNode {
  public func build(with context: YogaTreeContext) -> [YogaNode] {
    build(context)
  }
}
