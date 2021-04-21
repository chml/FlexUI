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
    let yogaNode = FlexNode()
    switch overlay {
    case .overlay(let overlayContent):
      overlayContent.build(with: context).forEach {
        $0.style.postionType = .absolute
        yogaNode.insertChild($0)
      }
      content.build(with: context).forEach {
        yogaNode.insertChild($0)
      }
    case .background(let backgroundContent):
      content.build(with: context).forEach {
        yogaNode.insertChild($0)
      }
      backgroundContent.build(with: context).forEach {
        $0.style.postionType = .absolute
        yogaNode.insertChild($0)
      }
    }
    return [yogaNode]
  }
}
