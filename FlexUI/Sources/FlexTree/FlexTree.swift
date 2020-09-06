//
//  FlexTree.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/31.
//

extension Node {
  public func buildFlexTree() -> FlexTree {
    let root = FlexNode()
    let context = FlexTreeContext(root: root, parent: root)
    let children = build(with: context)
    for child in children {
      root.insertChild(child)
    }
    return FlexTree(root: root)
  }
}

public struct FlexTreeContext {
  public let root: FlexNode
  public let parent: FlexNode

  public func with(parent newParent: FlexNode) -> FlexTreeContext {
    return FlexTreeContext(root: root, parent: newParent)
  }
}

public protocol YogaTreeBuildable {
  func build(with context: FlexTreeContext) -> [FlexNode]
}

public class FlexTree {
  public let node: FlexNode
  public var layout: YogaNodeLayout?

  public init(root: FlexNode) {
    self.node = root
  }

  @discardableResult
  public func calculateLayout(width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude, direction: Direction = .inherit) -> FlexTree {
    layout = node.calculateLayout(width: width, height: height, direction: direction)
//    print("\(node)")
    return self
  }

  public func makeViews(in rootView: UIView) {
    guard let layout = layout else {
      return
    }
    struct LayoutNode {
      let node: FlexNode
      let parentView: UIView
      let recycler: ViewRecycler
    }

    let rootRecycler = ViewRecycler.recycler(for: rootView)
    rootRecycler.prepareRecycling()
    var processedRecylers: [ViewRecycler] = [rootRecycler]
    var deferConfigs: [() -> Void] = []
    var stack: [LayoutNode] = [.init(node: layout.root, parentView: rootView, recycler: rootRecycler)]
    while !stack.isEmpty {
      let current = stack.removeLast()
      let node = current.node
      var parentView = current.parentView
      var recycler = current.recycler
      if let viewProducer = node.viewProducer {
        let view = recycler.makeOrRecycleView(for: node)
        view.frame = node.convertedLayoutFrame
        if node.parent?.style.overflow == .some(.scroll) {
          var frame = view.frame
          frame.origin.x = max(0, frame.origin.x)
          view.frame = frame
        }
        parentView.addSubview(view)
        if let config = viewProducer.configure {
          config(view)
        }
        if let config = viewProducer.deferConfigure {
          deferConfigs.append {
            config(view)
          }
        }
        parentView = view
        if node.asRootNode {
          recycler = ViewRecycler.recycler(for: view)
          recycler.prepareRecycling()
          processedRecylers.append(recycler)
        }
      }
      node.children.forEach { (child) in
        stack.append(.init(node: child, parentView: parentView, recycler: recycler))
      }
    }
    processedRecylers.forEach {
      $0.flush()
    }
    deferConfigs.forEach {
      $0()
    }

  }

}


extension FlexTree: CustomDebugStringConvertible {
  public var debugDescription: String {
    return node.debugDescription
  }
}

