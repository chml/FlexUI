//
//  Then.swift
//  FlexUI
//
//  Created by Li ChangMing on 2021/9/30.
//

import Foundation

public protocol Then {}

extension NSObject: Then {}

extension Then where Self: AnyObject {
  public func then(_ closure: (Self) throws -> Void) rethrows -> Self {
    try closure(self)
    return self
  }
}
