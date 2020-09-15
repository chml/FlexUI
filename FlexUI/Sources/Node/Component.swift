//
//  Component.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/9/8.
//

/*
 Component is a Stateful Node, Use a Coordinator to coordinate UI event and State
 */

public protocol Component: Node {
  associatedtype Coordinator: ComponentCoordinator

  func body(with coordinator: Coordinator) -> Body

  func coordinator(with context: CoordinatorContext<Self, Coordinator>) -> Coordinator
}

extension Component where Body == AnyNode {

  public func body(with coordinator: SimpleCoordinator<Self>) -> AnyNode {
    fatalError()
  }

}

extension Component where Coordinator.Content == Self {
  public func coordinator(with context: CoordinatorContext<Self, Coordinator>) -> Coordinator {
    Coordinator(with: context)
  }
}

extension Component where Coordinator == SimpleCoordinator<Self>{

  public func coordinator(with context: CoordinatorContext<Self, SimpleCoordinator<Self>>) -> SimpleCoordinator<Self> {
    SimpleCoordinator(with: context)
  }

  func body(with coordinator: SimpleCoordinator<Self>) -> AnyNode {
    return AnyNode(EmptyNode())
  }

}


extension Component {
  public var isComponent: Bool { return true }

  public var body: Body {
    fatalError("Use body(with coordinator:) instead")
  }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let flexNode = FlexNode()
    flexNode.asRootNode = true
//    print("build flexNode: \(flexNode)")
    let coordinatorContext = CoordinatorContext<Self, Coordinator>(current: {
      return self as Self
    }, updated: { [weak flexNode] (content, coordinator, animated) in
//      print("update flexNode: \(flexNode)")
//      print("update flexNode parent: \(flexNode?.parent)")
//      print("tree: \(context.tree)")
      guard let flexNode = flexNode, let parent = flexNode.parent else { return }
      if let index = parent.indexOfChild(flexNode) {
        parent.removeChild(flexNode)
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
      }
    )
    let coordinator = self.coordinator(with: coordinatorContext)
    flexNode.coordinator = coordinator
    let bodyNodes = body(with: coordinator).build(with: context.with(parent: flexNode))
    for n in bodyNodes {
      flexNode.insertChild(n)
    }
    return [flexNode]
  }
}

