//
//  FlexExt.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/9/9.
//


public final class Flex<Base> {
  public let base: Base
  public init(_ base: Base) {
    self.base = base
  }
}

public protocol FlexExComatible {

  associatedtype FlexExBase

  static var flex: Flex<FlexExBase>.Type { get }

  var flex: Flex<FlexExBase> { get }

}

extension FlexExComatible {

  public static var flex: Flex<Self>.Type {
    Flex<Self>.self
  }

  public var flex: Flex<Self> {
    Flex(self)
  }

}

import class Foundation.NSObject
extension NSObject: FlexExComatible {}
