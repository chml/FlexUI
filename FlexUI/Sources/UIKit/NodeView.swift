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
        superview?.layoutIfNeeded()
      }
    }
  }
  var nodeTree: FlexTree?

  public enum LayoutConstraint {
    case fitWidth(CGFloat)
    case fitHeight(CGFloat)
    case `default`
  }
  public var layout: LayoutConstraint

  public init(constraint: LayoutConstraint = .default, _ node: AnyNode) {
    self.layout = constraint
    self.node = node
    self.nodeTree = node.buildFlexTree()
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    setContentHuggingPriority(.defaultLow, for: .horizontal)
    setContentHuggingPriority(.defaultLow, for: .vertical)
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
    switch layout {
    case let .fitWidth(value):
      return sizeThatFits(CGSize(width: value, height: CGFloat.greatestFiniteMagnitude))
    case let .fitHeight(value):
      return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: value))
    default:
      return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }
  }

}
