//
//  DropShadow.swift
//  FlexUI
//
//  Created by Li ChangMing on 2021/9/29.
//

extension Node {
  public func dropShadow(_ shadow: Shadow, cornerRadius: CGFloat = 0, viewConfig: ((UIView) -> ())? = nil) -> DropShadow<Self> {
    DropShadow(with: self, shadow: shadow, cornerRadius: cornerRadius, viewConfig: viewConfig)
  }
}


public struct DropShadow<Content: Node>: Node {
  public typealias Body = Never
  let overlay: Overlay<Content, AnyNode>

  public init(with content: Content, shadow: Shadow, cornerRadius: CGFloat = 0, viewConfig: ((UIView) -> ())? = nil) {
    overlay = Overlay(content, backgroundContent: {
      View(of: DropShadowView.self)
        .viewConfig { v in
          v.layer.setShadow(shadow)
          v.layer.cornerRadius = cornerRadius
          viewConfig?(v)
        }
        .width(.percent(100))
        .height(.percent(100))
        .asAnyNode
    })
  }

}

extension DropShadow {
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    overlay.build(with: context)
  }
}

public final class DropShadowView: UIView {
}
