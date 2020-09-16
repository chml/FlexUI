//
//  UIViewController+Flex.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/9/10.
//

import class UIKit.UIViewController

extension Flex where Base: UIViewController, Base: Component {
  public func render() {
    base.view.flex.render(base)
  }
}

extension Flex where Base: UIViewController {

  public func render<Content: Node>(@NodeBuilder _ content: @escaping () -> Content) {
    base.view.flex.render(
      VCComponent(content: {
        AnyNode(content())
      }))
  }

}

private struct VCComponent: Component {
  typealias Body = AnyNode
  let content: () -> AnyNode

  func body(with coordinator: SimpleCoordinator<VCComponent>) -> AnyNode {
    return content()
  }
}
