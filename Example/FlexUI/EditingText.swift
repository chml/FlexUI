//
//  EditingText.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//


final class EditingText: Hashable {
  var text: String
  init(_ text: String) {
    self.text = text
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }

  static func == (lhs: EditingText, rhs: EditingText) -> Bool {
    return lhs === rhs
  }

}


