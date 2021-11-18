//
//  Component.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/8.
//


public protocol CoordinateNode: Node, ViewProducible where ProductedView == ComponentView<Self> {
  typealias NodeCoordinator = _NodeCoordinator<Self>
  associatedtype Coordinator: AnyNodeCoordinator

  func body(with coordinator: Coordinator) -> Body

  func coordinator(with context: CoordinatorContext<Self>) -> Coordinator
}


extension CoordinateNode where Coordinator: NodeCoordinator {
  public func coordinator(with context: CoordinatorContext<Self>) -> Coordinator {
    return Coordinator(with: context)
  }
}

extension CoordinateNode {
  public var isComponent: Bool { return true }

  public var body: Body {
    fatalError("Use func body(with coordinator:) instead")
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let containerFlexNode = FlexNode()
    let viewProducer = ViewProducer(type: ProductedView.self)
    viewProducer.reuseID = id
    containerFlexNode.viewProducer = viewProducer
    containerFlexNode.isContainerNode = true
    containerFlexNode.isWrapperNode = true
    containerFlexNode.style.flex = 0

    let coordinatorContext = CoordinatorContext<Self>(current: {
      return self as Self
    }, updated: { [weak containerFlexNode] (content,  animated) in
      guard let containerFlexNode = containerFlexNode, let parent = containerFlexNode.parent else { return }
      if let index = parent.indexOfChild(containerFlexNode) {
        parent.removeChild(containerFlexNode)
        content.build(with: context).forEach { (n) in // It should be only one flexNode in it;
          parent.insertChild(n, at: index)
        }
      }
      DispatchQueue.main.async {
        if animated {
          context.animator.stopAnimation(true)
          context.animator.addAnimations {
            context.tree.layoutIfNeed()
          }
          context.animator.startAnimation()
        } else {
          context.tree.layoutIfNeed()
        }
      }
    })
    let coordinator = self.coordinator(with: coordinatorContext)
    containerFlexNode.coordinator = coordinator
    body(with: coordinator).build(with: context.with(parent: containerFlexNode)).forEach { n in
      containerFlexNode.insertChild(n)
    }
    return [containerFlexNode]
  }
}

