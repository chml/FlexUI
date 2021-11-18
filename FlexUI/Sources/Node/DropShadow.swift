//
//  DropShadow.swift
//  FlexUI
//
//  Created by Li ChangMing on 2021/9/29.
//

extension Node {
  public func dropShadow(_ shadow: Shadow) -> DropShadow<Self> {
    DropShadow(shadow) {
      self as Self
    }
  }
}


public struct DropShadow<Content: Node>: Node {
  public typealias Body = Never
  let overlay: Overlay<Content, AnyNode>

  public init(_ shadow: Shadow, @NodeBuilder content: () -> Content) {
    overlay = Overlay(content(), backgroundContent: {
      View(of: DropShadowView.self)
        .viewConfig { v in
          v.layer.setShadow(shadow)
        }
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
