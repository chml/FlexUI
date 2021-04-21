//
//  ViewHighlighter.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/12/16.
//

import UIKit.UIView


extension UIView {

  var highlightedView: UIView? {
    let v = UIView()
    v.backgroundColor = .init(white: 0.3, alpha: 0.7)
    v.layer.cornerRadius = layer.cornerRadius
    v.layer.masksToBounds = true
    v.alpha = 0.3
    return v
  }

  func setHighlighted(_ hl: Bool, cornerRadius: CGFloat = 0.0) {
    viewWithTag(0x519510957)?.removeFromSuperview()
    if (hl) {
      if let v = highlightedView {
        if cornerRadius > 0.0 {
          v.layer.cornerRadius = cornerRadius
        }
        v.tag = 0x519510957
        v.frame = bounds
        addSubview(v)
      }
    }
  }

}
