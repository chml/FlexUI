//
//  NodeListBuildable.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/31.
//


extension Node {
  public func buildCells() -> [AnyNode] {
    return [AnyNode(self)]
  }
}
