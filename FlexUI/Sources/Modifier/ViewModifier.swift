//
//  ViewModifier.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/1.
//

extension ModifiedContent: ViewProducible where Content: ViewProducible {
  public typealias ProductedView = Content.ProductedView
}

extension Node where Self: ViewProducible {

  public func viewReuseID(_ id: AnyHashable) -> ModifiedContent<Self,ViewReuseIDModifier> {
    modifier(.init(reuseID: id))
  }

  public func viewMaker(_ maker: @escaping () -> UIView) -> ModifiedContent<Self,ViewMakerModifier> {
    modifier(.init(maker: maker))
  }

  public func viewConfig(_ config: @escaping (ProductedView) -> Void) -> ModifiedContent<Self, ViewConfigModifier<ProductedView>> {
    modifier(.init(config: config))
  }

}

public struct ViewReuseIDModifier: NodeModifier {
  let reuseID: AnyHashable

  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
    let contentYogaNodes = node.build(with: context)
    contentYogaNodes.forEach {
      $0.viewProducer?.reuseID = reuseID
    }
    return contentYogaNodes
  }
}

public struct ViewMakerModifier: NodeModifier {
  let maker: () -> UIView

  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
    let contentYogaNodes = node.build(with: context)
    contentYogaNodes.forEach {
      $0.viewProducer?.viewMaker = maker
    }
    return contentYogaNodes
  }
}

public struct ViewConfigModifier<View: UIView>: NodeModifier {
  let config: (View) -> Void

  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
    let contentYogaNodes = node.build(with: context)
    contentYogaNodes.forEach {
      $0.viewProducer?.appendConfiguration(as: View.self, config: config)
    }
    return contentYogaNodes
  }

}

