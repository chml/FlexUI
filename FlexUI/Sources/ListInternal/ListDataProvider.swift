//
//  ListDataProvider.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/4.
//

import Foundation

public final class ListDataProvider<Data> {

  public var data: Data

  public init(_ data: Data) {
    self.data = data
  }

}
