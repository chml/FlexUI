//
//  NodeView.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/3.
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

  public init(_ node: AnyNode) {
    self.node = node
    self.nodeTree = node.buildFlexTree()
    super.init(frame: .zero)
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    nodeTree?.render(in: self)
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    if size == .zero {
      nodeTree?.calculateLayout(width: .greatestFiniteMagnitude, height: .greatestFiniteMagnitude, direction: flex.direction)
    } else {
      nodeTree?.calculateLayout(width: size.width, height: size.height, direction: flex.direction)
    }
    return nodeTree?.layout?.contentSize ?? .zero
  }

  open override var intrinsicContentSize: CGSize {
    return sizeThatFits(CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude))
  }

}
