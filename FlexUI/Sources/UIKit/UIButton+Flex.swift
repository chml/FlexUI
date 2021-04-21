//
//  UIButtonExtensions.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/9.
//

import class UIKit.UIButton

private struct Key {
  static var action: Int8 = 0
}

extension Flex where Base: UIButton {

  public var action: (() -> Void)? {
    set {
      objc_setAssociatedObject(base, &Key.action, newValue, .OBJC_ASSOCIATION_RETAIN)
      base.removeTarget(base, action: #selector(UIButton.click(_:)), for: .touchUpInside)
      base.addTarget(base, action: #selector(UIButton.click(_:)), for: .touchUpInside)
    }
    get { objc_getAssociatedObject(base, &Key.action) as? (() -> Void) }
  }

}

extension UIButton {

  @objc
  fileprivate func click(_ sender: UIButton) {
    flex.action?()
  }

}
