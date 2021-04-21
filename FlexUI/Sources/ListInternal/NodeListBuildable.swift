//
//  NodeListBuildable.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/31.
//


extension Node {
  public func buildCells() -> [AnyNode] {
    return [AnyNode(self)]
  }
}
