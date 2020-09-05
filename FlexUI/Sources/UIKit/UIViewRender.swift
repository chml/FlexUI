//
//  UIViewRender.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/9/5.
//

import UIKit


extension UIView {

  public func render<Content: Node>(node: Content) {
    node.buildYogaTree()
      .calculateLayout(width: bounds.width, height: bounds.height, direction: direction)
      .makeViews(in: self)
  }

}

