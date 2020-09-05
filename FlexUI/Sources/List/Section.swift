//
//  Section.swift
//  YogaUI
//
//  Created by 黎昌明 on 2020/8/21.
//

import DifferenceKit


public struct Section {

  public let id: AnyHashable
  public let header: Cell?
  public let footer: Cell?
  public let cells: [Cell]

  public init(id: AnyHashable, header: Cell? = nil, footer: Cell? = nil, cells: [Cell]) {
    self.id = id
    self.header = nil
    self.footer = nil
    self.cells = cells
  }

}

extension Section: DifferenceKit.DifferentiableSection {

  public var differenceIdentifier: AnyHashable {
    return id
  }

  public var elements: [Cell] {
    return cells
  }

  public func isContentEqual(to source: Section) -> Bool {
    return header.isContentEqual(to: source.header) && footer.isContentEqual(to: source.footer)
  }

  public init<C: Swift.Collection>(source: Self, elements: C) where C.Element == Cell {
    self.init(id: source.id, header: source.header, footer: source.footer, cells: Array(elements))
  }

}


