//
//  Overlay.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/3.
//

extension Node {
  public func overlay<Content: Node>(@NodeBuilder _ content: @escaping () -> Content) -> Overlay<Self, Content> {
    Overlay(self, overlayContent: content)
  }

  public func background<Content: Node>(@NodeBuilder _ content: @escaping () -> Content) -> Overlay<Self, Content> {
    Overlay(self, backgroundContent: content)
  }
}

public struct Overlay<Content: Node, OverlayContent: Node>: Node {
  public typealias Body = Never

  enum OverlayType {
    case overlay(OverlayContent)
    case background(OverlayContent)
  }
  let overlay: OverlayType
  let content: Content

  public init(_ content: Content, @NodeBuilder overlayContent: @escaping () -> OverlayContent) {
    self.content = content
    self.overlay = .overlay(overlayContent())
  }

  public init(_ content: Content, @NodeBuilder backgroundContent: @escaping () -> OverlayContent) {
    self.content = content
    self.overlay = .background(backgroundContent())
  }
}

extension Overlay {
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let flexNode = FlexNode()
    switch overlay {
    case .overlay(let overlayContent):
      overlayContent.build(with: context).forEach {
        $0.style.postionType = .absolute
        flexNode.insertChild($0)
      }
      content.build(with: context).forEach {
        flexNode.copySytle(from: $0)
        if $0.nodeType == .text {
          flexNode.style.setPadding(of: .all, value: .point(0))
        }
        flexNode.insertChild($0)
      }
    case .background(let backgroundContent):
      content.build(with: context).forEach {
        flexNode.copySytle(from: $0)
        if $0.nodeType == .text {
          flexNode.style.setPadding(of: .all, value: .point(0))
        }
        flexNode.insertChild($0)
      }
      backgroundContent.build(with: context).forEach {
        $0.style.postionType = .absolute
        flexNode.insertChild($0)
      }
    }
    flexNode.style.flex = 0
    return [flexNode]
  }
}
