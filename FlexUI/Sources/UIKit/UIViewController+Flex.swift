//
//  UIViewController+Flex.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/10.
//

import class UIKit.UIViewController

extension Flex where Base: UIViewController, Base: Component {
  public func render(_ direction: Direction? = nil) {
    base.view.flex.render(base, direction: direction)
//    #if DEBUG
//    print("\(base.view.flex.tree!)")
//    #endif
  }
}

extension Flex where Base: UIViewController {

  public func render<Content: Node>(_ direction: Direction? = nil, @NodeBuilder _ content: @escaping () -> Content) {
    base.view.flex.render(
      VCComponent(content: {
        AnyNode(content())
      }), direction: direction)
  }

}

private struct VCComponent: Component {
  typealias Body = AnyNode
  let content: () -> AnyNode

  func body(with coordinator: SimpleCoordinator<VCComponent>) -> AnyNode {
    return content()
  }
}
