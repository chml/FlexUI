//
//  ComponentModifier.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/9.
//


extension CoordinateNode where Self == Self.Coordinator.Content {

  public func coordinate(_ setup: @escaping (Self.Coordinator) -> ()) -> ModifiedContent<Self, CoordinateNodeModifier<Self>> {
    modifier(CoordinateNodeModifier(setup: setup))
  }

}

public struct CoordinateNodeModifier<Content: CoordinateNode>: NodeModifier where Content.Coordinator.Content == Content {

  let setup: (Content.Coordinator) -> Void

  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
    let flexNodes = node.build(with: context)
    for n in flexNodes {
      if let coordinator = n.coordinator as? Content.Coordinator {
        setup(coordinator)
      }
    }
    return flexNodes
  }

}
