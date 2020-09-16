//

//  Node.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/26.
//

public typealias FLNode = Node
public protocol Node: YogaTreeBuildable, Diffable, CellBuildable {
  associatedtype Body: Node
  var body: Body { get }

  var isComponent: Bool { get }
}

extension Node {
  public var isComponent: Bool { true }

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    if isComponent {
      let flexNode = FlexNode()
      let viewProducer = ViewProducer(type: ComponentView<Self>.self)
      viewProducer.reuseID = id
      flexNode.viewProducer = viewProducer
      flexNode.asRootNode = true
      let bodyNodes = body.build(with: context)
      bodyNodes.forEach { (n) in
        flexNode.insertChild(n)
      }
      return [flexNode]
    } else{
      return body.build(with: context)
    }
  }
}

final class ComponentView<T>: UIView { }

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

