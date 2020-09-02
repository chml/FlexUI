//
//  NodeListBuildable.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/31.
//


extension Node {
  public func buildCells() -> [Cell] {
    return [Cell(node: self)]
  }

  public func buildSections() -> [Section] {
    return Cell(node: self).buildSections()
  }
}
