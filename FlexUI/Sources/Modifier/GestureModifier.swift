//
//  GestureModifier.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/10.
//


extension Node where Self: ViewProducible {

}

public struct GestureModeifier<Gesture: UIGestureRecognizer>: NodeModifier {
  let gesture: Gesture
  let action: (Gesture) -> Void
  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
//    UIPanGestureRecognizer(target: <#T##Any?#>, action: <#T##Selector?#>)
    let flexNodes = node.build(with: context)
    flexNodes.forEach { (n) in
      n.viewProducer?.appendConfiguration(config: { (view) in
//        view.addGestureRecognizer(gesture)
      })
    }
    return flexNodes
  }
}


//private Keys {
//  static 
//}

extension UIGestureRecognizer {
}
