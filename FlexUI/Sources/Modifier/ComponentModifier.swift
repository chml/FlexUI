//
//  ComponentModifier.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/9.
//


extension Component where Self == Self.Coordinator.Content {

  public func onUpdated(_ updated: @escaping (Self) -> Void) -> ModifiedContent<Self, ComponentModifier<Self>> {
    modifier(ComponentModifier(onUpdated: updated))
  }

}

public struct ComponentModifier<Content: Component>: NodeModifier, Hashable where Content.Coordinator.Content == Content {
  let onUpdated: (Content) -> Void

  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
    let flexNodes = node.build(with: context)
    for n in flexNodes {
      if let coordinator = n.coordinator as? Content.Coordinator {
        coordinator.context.onContentUpdated = onUpdated
      }
    }
    return flexNodes
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(UniqueIdentifier())
  }

  public static func == (lhs: ComponentModifier<Content>, rhs: ComponentModifier<Content>) -> Bool {
    return true
  }
}
