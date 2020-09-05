//
//  ColorExt.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

extension UIColor {
  static var random: UIColor {
    UIColor(red: CGFloat(arc4random()%255)/255.0, green: CGFloat(arc4random()%255)/255.0, blue: CGFloat(arc4random()%255)/255.0, alpha: 0.9)
  }
}
