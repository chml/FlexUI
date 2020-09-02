//
//  Flex.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/27.
//


public func Flex<T: Node>(@NodeBuilder _ builder: () -> T) -> AnyNode {
  return AnyNode(builder())
}
