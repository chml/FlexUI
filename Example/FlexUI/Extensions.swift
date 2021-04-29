//
//  Extensions.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2021/4/29.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

extension UIColor {
  static var random: UIColor {
    UIColor(red: CGFloat(arc4random()%255)/255.0, green: CGFloat(arc4random()%255)/255.0, blue: CGFloat(arc4random()%255)/255.0, alpha: 0.9)
  }
}

extension Array {
  func reversed(if reversed: Bool) -> [Element] {
    return reversed ? self.reversed() : self
  }
}
