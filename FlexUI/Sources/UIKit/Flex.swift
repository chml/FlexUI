//
//  FlexExt.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/9.
//


public final class Flex<Base> {
  public let base: Base
  public init(_ base: Base) {
    self.base = base
  }
}

public protocol FlexComatible {

  associatedtype FlexBase

  static var flex: Flex<FlexBase>.Type { get }

  var flex: Flex<FlexBase> { get }

}

extension FlexComatible {

  public static var flex: Flex<Self>.Type {
    Flex<Self>.self
  }

  public var flex: Flex<Self> {
    Flex(self)
  }

}

import class Foundation.NSObject
extension NSObject: FlexComatible {}
