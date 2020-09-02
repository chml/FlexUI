//
//  Cell.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/31.
//

import DifferenceKit

public final class Cell {
  public let node: AnyNode
  public var tree: YogaTree
  public var id: AnyHashable
  public var reuseID: String

  public init<T: Node>(node: T) {
    self.node = AnyNode(node)
    let tree = node.buildYogaTree()
    self.id = node.id
    self.reuseID = tree.node.viewProducer?.reuseID?.baseDesc ?? (tree.node.viewProducer?.viewTypeName ?? String(describing: "\(type(of: node))"))
    self.tree = tree
  }

  public func calculateLayout(width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude, direction: Direction = .inherit) {
    tree.calculateLayout(width: width, height: height, direction: direction)
  }

}


extension Cell: DifferenceKit.Differentiable {

  public var differenceIdentifier: AnyHashable {
    return id
  }

  public func isContentEqual(to source: Cell) -> Bool {
    return node.isContentEqual(to: source.node)
  }

}
