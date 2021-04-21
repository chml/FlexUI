//
//  NodeDiffable.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/31.
//


extension Node {
  public var id: AnyHashable {
    return String(describing: type(of: self))
  }

  public func isContentEqual(to other: Self) -> Bool {
    return false
  }
}

extension Node where Self == AnyNode {
  public var id: AnyHashable {
    return self.baseID
  }
  public func isContentEqual(to other: Self) -> Bool {
    return self.isEqualTo(other)
  }
}


extension Node where Self: Hashable {
  public var id: AnyHashable {
    return self
  }

  public func isContentEqual(to other: Self) -> Bool {
    return self == other
  }
}
