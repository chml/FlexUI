//
//  CALayer+Shadow.swift
//  FlexUI
//
//  Created by Li ChangMing on 2021/9/29.
//

import UIKit

extension CALayer {
  public func setShadow(_ shadow: Shadow, animated: Bool = false) {
    shadowColor = shadow.color.cgColor
    shadowOffset = CGSize(width: shadow.offset.x, height: shadow.offset.y)
    shadowRadius = shadow.blur / 2.0
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: maskedCorners.uiRectCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    if animated {
      let anim = CABasicAnimation(keyPath: #keyPath(shadowPath))
      anim.toValue = path.cgPath
      add(anim, forKey: "shadow")
    } else {
      shadowPath = path.cgPath
    }
  }
}

extension CACornerMask {
  var uiRectCorner: UIRectCorner {
    var corner: UIRectCorner = []
    if contains(.layerMinXMinYCorner) {
      corner.insert(.topLeft)
    }
    if contains(.layerMinXMaxYCorner) {
      corner.insert(.topRight)
    }
    if contains(.layerMaxXMinYCorner) {
      corner.insert(.bottomLeft)
    }
    if contains(.layerMaxXMaxYCorner) {
      corner.insert(.bottomRight)
    }
    return corner
  }
}
