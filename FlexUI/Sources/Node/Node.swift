//

//  Node.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/26.
//

public typealias FLNode = Node
public protocol Node: YogaTreeBuildable, Diffable, CellBuildable {
  associatedtype Body: Node
  var body: Body { get }

  var isComponent: Bool { get }
}


extension Node {
  public var isComponent: Bool { false }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
//    if isComponent {
//
//      let mirror = Mirror(reflecting: self)
//      for child in mirror.children {
//        print("Mirror:\(String(describing: self)): \(child)")
//      }
//      let flexNode = FlexNode()
//      flexNode.isWrapperNode = true
//      flexNode.style.flex = 0
//      let viewProducer = ViewProducer(type: ComponentView<Self>.self)
//      viewProducer.reuseID = id
//      flexNode.viewProducer = viewProducer
//      flexNode.asRootNode = true
//      let bodyNodes = body.build(with: context)
//      bodyNodes.forEach { (n) in
//        flexNode.insertChild(n)
//      }
//      return [flexNode]
//    } else{
      return body.build(with: context)
//    }
  }
}

public final class ComponentView<T>: UIView { }

public struct Never: Node {
  public typealias Body = Never
  
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    fatalError()
  }
}

extension Node where Body == AnyNode {
  public var body: Never {
    fatalError()
  }
}

extension Node where Body == Never {
  public var body: Never {
    fatalError()
  }
}

