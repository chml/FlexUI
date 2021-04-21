//
//  StyleModeifier.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/28.
//

extension Node {

//  @inlinable
//  public func style(_ config: @escaping (YogaStyle) -> Void) -> ModifiedContent<Self, StyleModifier> {
//    modifier(StyleModifier(config))
//  }

  @inlinable
  public func width(_ value: CGFloat) -> ModifiedContent<Self, SizingModifier> {
    width(.point(value))
  }

  @inlinable
  public func width(_ value: Value) -> ModifiedContent<Self, SizingModifier> {
    modifier(SizingModifier(dimension: .width, value: value))
  }

  @inlinable
  public func height(_ value: CGFloat) -> ModifiedContent<Self, SizingModifier> {
    height(.point(value))
  }

  @inlinable
  public func height(_ value: Value) -> ModifiedContent<Self, SizingModifier> {
    modifier(SizingModifier(dimension: .height, value: value))
  }

  @inlinable
  public func minWidth(_ value: CGFloat) -> ModifiedContent<Self, SizingModifier> {
    minWidth(.point(value))
  }

  @inlinable
  public func minWidth(_ value: Value) -> ModifiedContent<Self, SizingModifier> {
    modifier(SizingModifier(dimension: .minWidth, value: value))
  }

  @inlinable
  public func minHeight(_ value: CGFloat) -> ModifiedContent<Self, SizingModifier> {
    minHeight(.point(value))
  }

  @inlinable
  public func minHeight(_ value: Value) -> ModifiedContent<Self, SizingModifier> {
    modifier(SizingModifier(dimension: .minHeight, value: value))
  }

  @inlinable
  public func maxWidth(_ value: CGFloat) -> ModifiedContent<Self, SizingModifier> {
    maxWidth(.point(value))
  }

  @inlinable
  public func maxWidth(_ value: Value) -> ModifiedContent<Self, SizingModifier> {
    modifier(SizingModifier(dimension: .maxWidth, value: value))
  }

  @inlinable
  public func maxHeight(_ value: CGFloat) -> ModifiedContent<Self, SizingModifier> {
    maxHeight(.point(value))
  }

  @inlinable
  public func maxHeight(_ value: Value) -> ModifiedContent<Self, SizingModifier> {
    modifier(SizingModifier(dimension: .maxHeight, value: value))
  }

  @inlinable
  public func padding(_ insets: UIEdgeInsets) -> ModifiedContent<Self, InsetsModifier> {
    modifier(InsetsModifier(value: insets))
  }

  @inlinable
  public func padding(of edge: Edge = .all, _ value: CGFloat) -> ModifiedContent<Self, PositioningModifier> {
    padding(of: edge, .point(value))
  }

  @inlinable
  public func padding(of edge: Edge = .all, _ value: Value) -> ModifiedContent<Self, PositioningModifier> {
    modifier(PositioningModifier(demension: .padding, edge: edge, value: value))
  }

  @inlinable
  public func margin(of edge: Edge = .all, _ value: CGFloat) -> ModifiedContent<Self, PositioningModifier> {
    margin(of: edge, .point(value))
  }

  @inlinable
  public func margin(of edge: Edge = .all, _ value: Value) -> ModifiedContent<Self, PositioningModifier> {
    modifier(PositioningModifier(demension: .margin, edge: edge, value: value))
  }

  @inlinable
  public func position(of edge: Edge = .all, _ value: CGFloat) -> ModifiedContent<Self, PositioningModifier> {
    position(of: edge, .point(value))
  }

  @inlinable
  public func position(of edge: Edge = .all, _ value: Value) -> ModifiedContent<Self, PositioningModifier> {
    modifier(PositioningModifier(demension: .position, edge: edge, value: value))
  }

  @inlinable
  public func start(_ value: CGFloat) -> ModifiedContent<Self, PositioningModifier> {
    start(.point(value))
  }

  @inlinable
  public func start(_ value: Value) -> ModifiedContent<Self, PositioningModifier> {
    position(of: .start, value)
  }

  @inlinable
  public func end(_ value: CGFloat) -> ModifiedContent<Self, PositioningModifier> {
    end(.point(value))
  }

  @inlinable
  public func end(_ value: Value) -> ModifiedContent<Self, PositioningModifier> {
    position(of: .end, value)
  }

  @inlinable
  public func top(_ value: CGFloat) -> ModifiedContent<Self, PositioningModifier> {
    top(.point(value))
  }

  @inlinable
  public func top(_ value: Value) -> ModifiedContent<Self, PositioningModifier> {
    position(of: .top, value)
  }

  @inlinable
  public func left(_ value: CGFloat) -> ModifiedContent<Self, PositioningModifier> {
    left(.point(value))
  }

  @inlinable
  public func left(_ value: Value) -> ModifiedContent<Self, PositioningModifier> {
    position(of: .left, value)
  }

  @inlinable
  public func bottom(_ value: CGFloat) -> ModifiedContent<Self, PositioningModifier> {
    bottom(.point(value))
  }

  @inlinable
  public func bottom(_ value: Value) -> ModifiedContent<Self, PositioningModifier> {
    position(of: .bottom, value)
  }


  @inlinable
  public func right(_ value: CGFloat) -> ModifiedContent<Self, PositioningModifier> {
    right(.point(value))
  }

  @inlinable
  public func right(_ value: Value) -> ModifiedContent<Self, PositioningModifier> {
    position(of: .right, value)
  }


  @inlinable
  public func flex(_ value: CGFloat) -> ModifiedContent<Self, FlexModifier> {
    modifier(FlexModifier(.flex(value)))
  }

  @inlinable
  public func flexGrow(_ value: CGFloat) -> ModifiedContent<Self, FlexModifier> {
    modifier(FlexModifier(.flexGrow(value)))
  }

  @inlinable
  public func flexShrink(_ value: CGFloat) -> ModifiedContent<Self, FlexModifier> {
    modifier(FlexModifier(.flexShrink(value)))
  }

  @inlinable
  public func flexBasis(_ value: Value) -> ModifiedContent<Self, FlexModifier> {
    modifier(FlexModifier(.flexBasis(value)))
  }

  @inlinable
  public func alignSelf(_ value: Align) -> ModifiedContent<Self, FlexModifier> {
    modifier(FlexModifier(.alignSelf(value)))
  }

  @inlinable
  public func aspectRatio(_ value: CGFloat) -> ModifiedContent<Self, FlexModifier> {
    modifier(FlexModifier(.aspectRatio(value)))
  }

  @inlinable
  public func baselineFunc(_ thefunc: @escaping FlexNode.BaselineFunc) -> ModifiedContent<Self, BaselineModifier> {
    modifier(BaselineModifier(thefunc))
  }

}

//public struct StyleModifier: NodeModifier {
//  let config: (YogaStyle) -> Void
//
//  public init(_ config: @escaping (YogaStyle) -> Void) {
//    self.config = config
//  }
//
//  public func build<T>(node: T, with context: YogaTreeContext) -> [YogaNode] where T : Node {
//    return node.build(with: context).map { (node) -> YogaNode in
//      config(node.style)
//      return node
//    }
//  }
//
//}

public struct SizingModifier: NodeModifier {

  public enum Dimension {
    case width
    case height
    case minWidth
    case minHeight
    case maxWidth
    case maxHeight
  }
  let dimension: Dimension
  let value: Value

  public init(dimension: Dimension, value: Value) {
    self.dimension = dimension
    self.value = value
  }

  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
    let contentYogaNodes = node.build(with: context)
    switch dimension {
    case .width: contentYogaNodes.forEach { $0.style.width = value }
    case .height: contentYogaNodes.forEach { $0.style.height = value }
    case .minWidth: contentYogaNodes.forEach { $0.style.minWidth = value }
    case .minHeight: contentYogaNodes.forEach { $0.style.minHeight = value }
    case .maxWidth: contentYogaNodes.forEach { $0.style.maxWidth = value }
    case .maxHeight: contentYogaNodes.forEach { $0.style.maxHeight = value }
    }
    return contentYogaNodes
  }
}

public struct InsetsModifier: NodeModifier {
  let value: UIEdgeInsets
  public init(value: UIEdgeInsets) {
    self.value = value;
  }

  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
    let contentYogaNodes = node.build(with: context)
    contentYogaNodes.forEach { (n) in
      if value.top > 0 {
        n.style.setPadding(of: .top, value: .point(value.top))
      }
      if value.left > 0 {
        n.style.setPadding(of: .left, value: .point(value.left))
      }
      if value.bottom > 0 {
        n.style.setPadding(of: .bottom, value: .point(value.bottom))
      }
      if value.right > 0 {
        n.style.setPadding(of: .right, value: .point(value.right))
      }
    }
    return contentYogaNodes
  }
}

public struct PositioningModifier: NodeModifier {
  public enum Dimension {
    case padding
    case margin
    case position
  }
  let dimension: Dimension
  let edge: Edge
  let value: Value

  public init(demension: Dimension, edge: Edge, value: Value) {
    self.dimension = demension
    self.edge = edge
    self.value = value
  }

  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
    let contentYogaNodes = node.build(with: context)
    switch dimension {
    case .padding: contentYogaNodes.forEach { $0.style.setPadding(of: edge, value: value) }
    case .margin: contentYogaNodes.forEach { $0.style.setMargin(of: edge, value: value) }
    case .position: contentYogaNodes.forEach { $0.style.setPosition(of: edge, value: value) }
    }
    return contentYogaNodes
  }
}


public struct FlexModifier: NodeModifier {
  public enum DemensionValue {
    case flex(CGFloat)
    case flexGrow(CGFloat)
    case flexShrink(CGFloat)
    case flexBasis(Value)
    case alignSelf(Align)
    case aspectRatio(CGFloat)
  }
  let demensionValue: DemensionValue

  public init(_ demensionValue: DemensionValue) {
    self.demensionValue = demensionValue
  }

  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
    let contentYogaNodes = node.build(with: context)
    contentYogaNodes.first?.style.display = .flex
    switch demensionValue {
    case .flex(let value): contentYogaNodes.forEach { $0.style.flex = value }
    case .flexGrow(let value): contentYogaNodes.forEach { $0.style.flexGrow = value }
    case .flexShrink(let value): contentYogaNodes.forEach { $0.style.flexShrink = value }
    case .flexBasis(let value): contentYogaNodes.forEach { $0.style.flexBasis = value }
    case .alignSelf(let value): contentYogaNodes.forEach { $0.style.alignSelf = value }
    case .aspectRatio(let value): contentYogaNodes.forEach { $0.style.aspectRatio = value }
    }
    return contentYogaNodes
  }
}

public struct BaselineModifier: NodeModifier {
  var `func`: FlexNode.BaselineFunc
  public init(_ thefunc: @escaping FlexNode.BaselineFunc) {
    self.func = thefunc
  }

  public func build<T>(node: T, with context: FlexTreeContext) -> [FlexNode] where T : Node {
    let contentYogaNodes = node.build(with: context)
    contentYogaNodes.forEach { (n) in
      n.baselineFunc = self.func
    }
    return contentYogaNodes
  }
}
