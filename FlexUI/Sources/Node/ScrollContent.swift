//
//  ScrollContent.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/2.
//

extension Node {
  public func scrollable() -> ScrollContent<Self> {
    return ScrollContent {
      self as Self
    }
  }
}


public struct ScrollContent<Content: Node>: Node, ViewProducible {
  public typealias Body = Never
  public typealias ProductedView = UIScrollView
  let content: Content

  public init(@NodeBuilder content: () -> Content) {
    self.content = content()
  }
}

extension ScrollContent {
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let viewProducer = ViewProducer(type: ProductedView.self)
    viewProducer.appendDeferConfiguration(as: ProductedView.self) { (view) in
      DispatchQueue.main.async {
        view.adjustContentSizeForSubviews()
      }
    }
    let yogaNode = FlexNode()
    yogaNode.viewProducer = viewProducer
    yogaNode.style.overflow = .scroll

    let containerYogaNode = FlexNode()
    yogaNode.insertChild(containerYogaNode)
    let contentYogaNodes = content.build(with: context.with(parent: yogaNode))
    containerYogaNode.viewProducer = ViewProducer(type: UIView.self)

    containerYogaNode.viewProducer?.appendDeferConfiguration(config: { (v) in
      // WORKAROUND FIX for Horizontal Scrolling in RTL
      // TODO: Refactor
      var frame = v.frame
      frame.origin = .zero
      v.frame = frame
    })
    
    contentYogaNodes.forEach { (child) in
      containerYogaNode.insertChild(child)
    }
    return [yogaNode]
  }

}
