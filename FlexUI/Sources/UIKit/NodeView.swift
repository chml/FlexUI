//
//  NodeView.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/9/3.
//

import UIKit

open class NodeView: UIView {
  open var node: AnyNode? = nil {
    didSet {
      if let node = node {
        nodeTree = node.buildFlexTree()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
      }
    }
  }
  var nodeTree: FlexTree?

  open override func layoutSubviews() {
    super.layoutSubviews()
    nodeTree?.render(in: self)
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    nodeTree?.calculateLayout(width: size.width, height: size.height, direction: direction)
    return nodeTree?.layout?.contentSize ?? .zero
  }

  open override var intrinsicContentSize: CGSize {
    return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
  }

}
