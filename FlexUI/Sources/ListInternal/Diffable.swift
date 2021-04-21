//
//  Diffable.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/31.
//


// Use for List Diffing
public protocol Diffable {
  var id: AnyHashable { get }
  func isContentEqual(to other: Self) -> Bool
}
