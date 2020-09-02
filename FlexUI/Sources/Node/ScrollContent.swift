//
//  ScrollContent.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/9/2.
//


public struct ScrollContent<Content: Node>: Node, ViewProducible {
  public typealias Body = Never
  public typealias ProductedView = UIScrollView

  let content: Content

  public init(@NodeBuilder content: () -> Content) {
    self.content = content()
  }

}

extension ScrollContent {

  public func build(with context: YogaTreeContext) -> [YogaNode] {
    let viewProducer = ViewProducer(type: ProductedView.self)
    viewProducer.appendDeferConfiguration(as: ProductedView.self) { (view) in
      DispatchQueue.main.async {
        view.adjustContentSizeForSubviews()
      }
    }
    let yogaNode = YogaNode()
    yogaNode.viewProducer = viewProducer
    yogaNode.style.overflow = .scroll

    let containerYogaNode = YogaNode()
    yogaNode.insertChild(containerYogaNode)
    let contentYogaNodes = content.build(with: context.with(parent: yogaNode))

    if let direction = contentYogaNodes.first?.style.flexDirection {
      containerYogaNode.style.flexDirection = direction
      if direction == .row || direction == .column {
        containerYogaNode.style.alignSelf = .flexStart
      }
    }
    contentYogaNodes.forEach { (child) in
      containerYogaNode.insertChild(child)
    }

    return [yogaNode]
  }

}
