//
//  UIViewRender.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/9/5.
//

import UIKit


private struct AssociatedKey {
  static var flexTree: Int8 = 0
}

extension UIView {


  public var flexTree: FlexTree? {
    get { objc_getAssociatedObject(self, &AssociatedKey.flexTree) as? FlexTree }
    set { objc_setAssociatedObject(self, &AssociatedKey.flexTree, newValue, .OBJC_ASSOCIATION_RETAIN) }
  }

  public func render<Content: Node>(node: Content) {
    node.buildFlexTree()
      .calculateLayout(width: bounds.width, height: bounds.height, direction: direction)
      .render(in: self)
  }

  func adjustSizeForTreeIfNeed() {
    guard let layout = self.flexTree?.layout else {
      return
    }
    
    var viewFrame = self.frame
    viewFrame.size = layout.contentSize
//    viewFrame.size.width = max(viewFrame.width, layout.contentSize.width)
//    viewFrame.size.height = max(viewFrame.height, layout.contentSize.height)
    self.frame = viewFrame

    var superview: UIView? = self.superview
    while superview != nil {
      if let tableView = superview as? UITableView {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        break
      }
      superview = superview?.superview
    }
  }
}

