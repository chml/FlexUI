//
//  Diffable.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/31.
//


public protocol Diffable {
  var id: AnyHashable { get }
  func isContentEqual(to other: Self) -> Bool
}
