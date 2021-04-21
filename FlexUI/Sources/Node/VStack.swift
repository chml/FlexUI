//
//  VStack.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/27.
//


public struct VStack<Content: Node>: Node {
  public var body: Never = Never()

  let reverse: Bool
  let spacing: CGFloat
  let justifyContent: Justify
  let alignItems: Align
  let wrap: FlexWrap
  let alignContent: Align
  let lineSpacing: CGFloat
  let content: Content

  public init(reverse: Bool = false,
              spacing: CGFloat = 0,
              justifyContent: Justify = .flexStart,
              alignItems: Align = .flexStart,
              wrap: FlexWrap = .noWrap,
              alignContent: Align = .flexStart,
              lineSpacing: CGFloat = 0,
              @NodeBuilder _ content: () -> Content) {
    self.reverse        = reverse
    self.spacing        = spacing
    self.justifyContent = justifyContent
    self.alignItems     = alignItems
    self.wrap           = wrap
    self.alignContent   = alignContent
    self.lineSpacing    = lineSpacing
    self.content        = content()
  }

}


extension VStack {

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let yogaNode = FlexNode()
    yogaNode.style.flexDirection = reverse ? .columnReverse : .column
    yogaNode.style.justifyContent = justifyContent
    yogaNode.style.alignItems = alignItems
    yogaNode.style.flexWrap = wrap
    let children = content.build(with: context.with(parent: yogaNode))
    children.forEach { (child) in
      if spacing > 0 {
        child.style.setMargin(of: .top, offset: spacing)
      }
      if lineSpacing > 0 {
        child.style.setMargin(of: .start, offset: lineSpacing)
      }
      yogaNode.insertChild(child)
    }
    if spacing > 0 {
      yogaNode.style.setMargin(of: .top, offset: -spacing)
    }
    if lineSpacing > 0 {
      yogaNode.style.setMargin(of: .start, offset: -lineSpacing)
    }
    return [yogaNode]
  }
}
