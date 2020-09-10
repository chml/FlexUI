//
//  ComponentCoordinator.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/9/8.
//

public final class CoordinatorContext<Content: Node, Coordinator> {

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

public protocol AnyComponentCoordinator: AnyObject { }

public protocol ComponentCoordinator: AnyComponentCoordinator {
  associatedtype Content: Node
  typealias Context = CoordinatorContext<Content, Self>
  var context: Context { get }

  init(with context: Context)

  func update(animated: Bool, _ action:(inout Content) -> Void)
}

extension ComponentCoordinator {

  public func update(animated: Bool = false, _ action:(inout Content) -> Void) {
    context.update(with: self, animated: animated, action)
  }

}

public final class SimpleCoordinator<Content: Node>: ComponentCoordinator {
  public typealias Context = CoordinatorContext<Content, SimpleCoordinator<Content>>
  public let context: Context
  public init(with context: Context) {
    self.context = context
  }
}
