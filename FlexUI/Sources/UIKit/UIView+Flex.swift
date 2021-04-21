//
//  UIView+Flex.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/16.
//

import class UIKit.UIView

private struct Key {
  static var flexTree: Int8 = 0
}

extension Flex where Base: UIView {

  public var direction: Direction {
    switch UIView.userInterfaceLayoutDirection(for: base.semanticContentAttribute) {
    case .leftToRight: return .LTR
    case .rightToLeft: return .RTL
    @unknown default:
      return .LTR
    }
  }


  public var tree: FlexTree? {
    get { objc_getAssociatedObject(base, &Key.flexTree) as? FlexTree }
    set { objc_setAssociatedObject(base, &Key.flexTree, newValue, .OBJC_ASSOCIATION_RETAIN) }
  }
  
  public func render<Content: Node>(_ node: Content, direction: Direction? = nil) {
    node.buildFlexTree()
      .calculateLayout(width: base.bounds.width, height: base.bounds.height, direction: direction ?? base.flex.direction)
      .render(in: base)
  }

}

extension UIView {

  func adjustSizeForTreeIfNeed() {
    guard let layout = flex.tree?.layout else {
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

