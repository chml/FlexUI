//
//  SomeNode.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/2.
//

import Foundation

//public struct SomeNode: Node {
//  public typealias Body = Never
//  fileprivate let base: Any
//  fileprivate let build: (YogaTreeContext) -> [YogaNode]
//  fileprivate let isEqualTo: (SomeNode) -> Bool
//  public let id: AnyHashable
//
//  public init<T: Node>(_ baseNode: T) {
//    self.id = baseNode.id
//    self.base = baseNode
//    self.isEqualTo = { (other) -> Bool in
//      if let otherBase = other.base as? T {
//        return baseNode.isContentEqual(to: otherBase)
//      }
//      return false
//    }
//    build = { (context) -> [YogaNode] in
//      baseNode.build(with: context)
//    }
//  }
//
//  public func unwrap<T>(as _: T.Type) -> T? {
//    return base as? T
//  }
//
//  public func isContentEqual(to other: SomeNode) -> Bool {
//    return isEqualTo(other)
//  }
//
//}
//
//extension SomeNode {
//  public func build(with context: YogaTreeContext) -> [YogaNode] {
//    build(context)
//  }
//}
