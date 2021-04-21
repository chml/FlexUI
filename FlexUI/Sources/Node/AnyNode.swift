//
//  AnyNode.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/27.
//

extension Node {
  public var asAnyNode: AnyNode {
    AnyNode(self)
  }
}

public struct AnyNode: Node {
  public typealias Body = Never
  fileprivate let base: Any
  fileprivate let build: (FlexTreeContext) -> [FlexNode]
  public let typeName: String
  internal let baseID: AnyHashable
  internal let isEqualTo: (AnyNode) -> Bool
  internal var baseIDIsDefault: Bool {
    return self.id == AnyHashable(String(describing: type(of: base))) // NodeDiffalbe.swift
  }

  public init<T: Node>(_ baseNode: T) {
    self.baseID = baseNode.id
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

