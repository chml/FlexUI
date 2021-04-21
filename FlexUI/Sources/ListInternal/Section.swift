//
//  Section.swift
//  YogaUI
//
//  Created by Li ChangMing on 2020/8/21.
//

import DifferenceKit


public struct Section {

  public let id: AnyHashable
  public let header: AnyNode?
  public let footer: AnyNode?
  public let cells: [AnyNode]

  public init(id: AnyHashable, header: AnyNode? = nil, footer: AnyNode? = nil, cells: [AnyNode]) {
    self.id = id
    self.header = nil
    self.footer = nil
    self.cells = cells
  }

}

extension AnyNode: Differentiable {

  public var differenceIdentifier: AnyHashable {
    return id
  }

  public func isContentEqual(to source: AnyNode) -> Bool {
    return isEqualTo(source)
  }

}

extension Section: DifferenceKit.DifferentiableSection {

  public var differenceIdentifier: AnyHashable {
    return id
  }

  public var elements: [AnyNode] {
    return cells
  }

  public func isContentEqual(to source: Section) -> Bool {
    return header.isContentEqual(to: source.header) && footer.isContentEqual(to: source.footer)
  }

  public init<C: Swift.Collection>(source: Self, elements: C) where C.Element == AnyNode {
    self.init(id: source.id, header: source.header, footer: source.footer, cells: Array(elements))
  }

}


