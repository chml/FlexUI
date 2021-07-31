//
//  ComponentCoordinator.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/8.
//


public protocol AnyNodeCoordinator: AnyObject {

  func setHighlighted(_ highlighted: Bool, animated: Bool)

  func willDisplay(_ view: UIView)

  func didEndDisplaying(_ view: UIView)

}

public protocol NodeCoordinator: AnyNodeCoordinator {
  associatedtype Content: CoordinateNode
  typealias Context = CoordinatorContext<Content, Self>
  var context: Context { get }

  init(with context: Context)

  func update(animated: Bool, _ action:(inout Content) -> Void)
}

extension NodeCoordinator {

  public var content: Content { context.current() }

  public func update(animated: Bool = false, _ action:(inout Content) -> Void) {
    context.update(with: self, animated: animated, action)
  }

  public func setHighlighted(_ highlighted: Bool, animated: Bool) {
    let current = context.current()
    if current.isHighlightable && current.isHighlighted != highlighted {
      context.update(with: self, animated: animated) {
        $0.isHighlighted = highlighted
      }
    }
  }

  public func willDisplay(_ view: UIView) { }
  
  public func didEndDisplaying(_ view: UIView) { }

}

public final class CoordinatorContext<Content: CoordinateNode, Coordinator> {

  public let current: () -> Content
  public let updated: (Content, Coordinator, Bool) -> Void
  public var onContentUpdated: ((Content) -> Void)? = nil

  public init(current: @escaping () -> Content, updated: @escaping (Content, Coordinator, Bool) -> Void) {
    self.current = current
    self.updated = updated
  }

  public func update(with coordinator: Coordinator, animated: Bool = false, _ action:(inout Content) -> Void) {
    var new = current()
    action(&new)
    onContentUpdated?(new)
    updated(new, coordinator, animated)
  }

}

public final class DefaultCoordinator<Content: CoordinateNode>: NodeCoordinator {
  public typealias Context = CoordinatorContext<Content, DefaultCoordinator<Content>>
  public let context: Context
  public init(with context: Context) {
    self.context = context
  }
}
