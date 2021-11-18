//
//  ComponentCoordinator.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/8.
//


public protocol AnyNodeCoordinator: AnyObject {

  // Only Work with UITableViewCell/UICollecionViewCell
  func setHighlighted(_ highlighted: Bool, animated: Bool)

  // Only Work with UITableViewCell/UICollecionViewCell
  func willDisplay(_ view: UIView)

  // Only Work with UITableViewCell/UICollecionViewCell
  func didEndDisplaying(_ view: UIView)

  // 调用时，UIView Tree 已经完成构建和布局
  func didLoad()

}

open class _NodeCoordinator<ContentNode: CoordinateNode>: NSObject, AnyNodeCoordinator {
  public typealias Context = CoordinatorContext<ContentNode>
  public let context: Context

  required public init(with context: Context) {
    self.context = context
  }

  public func update(animated: Bool = false, _ updater: (inout ContentNode) -> Void) {
    context.update(animated: animated, updater)
  }

  open func setHighlighted(_ highlighted: Bool, animated: Bool) { }
  open func willDisplay(_ view: UIView) { }
  open func didEndDisplaying(_ view: UIView) { }
  open func didLoad() { }
}


public struct CoordinatorContext<ContentNode: CoordinateNode> {

  public let current: () -> ContentNode
  public let updated: (ContentNode, _ animated: Bool) -> Void
  public var onContentUpdated: ((ContentNode) -> Void)? = nil

  public init(current: @escaping () -> ContentNode, updated: @escaping (ContentNode,  Bool) -> Void) {
    self.current = current
    self.updated = updated
  }

  public func update(animated: Bool = false, _ action:(inout ContentNode) -> Void) {
    var new = current()
    action(&new)
    onContentUpdated?(new)
    updated(new, animated)
  }

}
