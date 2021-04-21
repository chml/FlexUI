//
//  FlexStyle.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/27.
//

import yoga


public final class FlexStyle  {

  private let ref: YGNodeRef

  init(nodeRef: YGNodeRef) {
    ref = nodeRef
  }

  public var direction: Direction {
    get { YGNodeStyleGetDirection(ref) }
    set { YGNodeStyleSetDirection(ref, newValue) }
  }

  public var overflow: Overflow {
    get { YGNodeStyleGetOverflow(ref) }
    set { YGNodeStyleSetOverflow(ref, newValue) }
  }

  public var display: Display {
    get { YGNodeStyleGetDisplay(ref) }
    set { YGNodeStyleSetDisplay(ref, newValue) }
  }

  public var flex: CGFloat {
    get { YGNodeStyleGetFlex(ref).cgFloat }
    set { YGNodeStyleSetFlex(ref, newValue.float)}
  }

  public var flexDirection: FlexDirection {
    get { YGNodeStyleGetFlexDirection(ref) }
    set { YGNodeStyleSetFlexDirection(ref, newValue) }
  }

  public var justifyContent: Justify {
    get { YGNodeStyleGetJustifyContent(ref) }
    set { YGNodeStyleSetJustifyContent(ref, newValue) }
  }

  public var alignContent: Align {
    get { YGNodeStyleGetAlignContent(ref) }
    set { YGNodeStyleSetAlignContent(ref, newValue) }
  }

  public var alignItems: Align {
    get { YGNodeStyleGetAlignItems(ref) }
    set { YGNodeStyleSetAlignItems(ref, newValue) }
  }

  public var alignSelf: Align {
    get { YGNodeStyleGetAlignSelf(ref) }
    set { YGNodeStyleSetAlignSelf(ref, newValue) }
  }

  public var postionType: PositionType {
    get { YGNodeStyleGetPositionType(ref) }
    set { YGNodeStyleSetPositionType(ref, newValue) }
  }

  public var flexWrap: FlexWrap  {
    get { YGNodeStyleGetFlexWrap(ref) }
    set { YGNodeStyleSetFlexWrap(ref, newValue) }
  }

  public var flexGrow: CGFloat {
    get { CGFloat(YGNodeStyleGetFlexGrow(ref)) }
    set { YGNodeStyleSetFlexGrow(ref, newValue.float) }
  }

  public var flexShrink: CGFloat {
    get { CGFloat(YGNodeStyleGetFlexShrink(ref)) }
    set { YGNodeStyleSetFlexShrink(ref, newValue.float) }
  }

  public var flexBasis: Value {
    get { YGNodeStyleGetFlexBasis(ref) }
    set {
      switch newValue.unit {
      case .auto: YGNodeStyleSetFlexBasisAuto(ref)
      case .point: YGNodeStyleSetFlexBasis(ref, newValue.value)
      case .percent: YGNodeStyleSetFlexBasisPercent(ref, newValue.value)
      case .undefined: break
      @unknown default: break
      }
    }
  }

  public func margin(of edge: Edge) -> Value {
    return YGNodeStyleGetMargin(ref, edge)
  }

  public func setMargin(of edge: Edge, value: Value) {
    switch value.unit {
    case .point: YGNodeStyleSetMargin(ref, edge, value.value)
    case .percent: YGNodeStyleSetMarginPercent(ref, edge, value.value)
    case .auto: YGNodeStyleSetMarginAuto(ref, edge)
    case .undefined: break
    @unknown default: break
    }
  }

  public func position(of edge: Edge) -> Value {
    return YGNodeStyleGetPosition(ref, edge)
  }

  public func setPosition(of edge: Edge, value: Value) {
    switch value.unit {
    case .point: YGNodeStyleSetPosition(ref, edge, value.value)
    case .percent: YGNodeStyleSetPositionPercent(ref, edge, value.value)
    case .auto: break
    case .undefined: break
    @unknown default: break
    }
  }

  public func padding(of edge: Edge) -> Value {
    return YGNodeStyleGetPadding(ref, edge)
  }

  public func paddingInsets() -> UIEdgeInsets {
    var insets: UIEdgeInsets = .zero
    let all = padding(of: .all)
    if all.unit == .point && !all.value.isNaN {
      insets = UIEdgeInsets(top: all.value.cgFloat, left: all.value.cgFloat, bottom: all.value.cgFloat, right: all.value.cgFloat)
    }

    let horizontal = padding(of: .horizontal)
    if horizontal.unit == .point && !horizontal.value.isNaN {
      insets.left = horizontal.value.cgFloat
      insets.right = horizontal.value.cgFloat
    }

    let vertical = padding(of: .vertical)
    if vertical.unit == .point && !vertical.value.isNaN {
      insets.top = vertical.value.cgFloat
      insets.bottom = vertical.value.cgFloat
    }

    let top = padding(of: .top)
    if top.unit == .point && !top.value.isNaN {
      insets.top = top.value.cgFloat
    }

    let left = padding(of: .left)
    if left.unit == .point && !left.value.isNaN {
      insets.left = left.value.cgFloat
    }

    let bottom = padding(of: .top)
    if bottom.unit == .point && !bottom.value.isNaN {
      insets.bottom = top.value.cgFloat
    }

    let right = padding(of: .right)
    if right.unit == .point && !right.value.isNaN {
      insets.right = right.value.cgFloat
    }
    return insets
  }

  public func setPadding(of edge: Edge, value: Value) {
    switch value.unit {
    case .point: YGNodeStyleSetPadding(ref, edge, value.value)
    case .percent: YGNodeStyleSetPaddingPercent(ref, edge, value.value)
    case .auto: break
    case .undefined: break
    @unknown default: break
    }
  }


  public func border(of edge: Edge) -> CGFloat {
    return CGFloat(YGNodeStyleGetBorder(ref, edge))
  }

  public func setBorder(of edge: Edge, value: CGFloat) {
    YGNodeStyleSetBorder(ref, edge, value.float)
  }

  public var width: Value {
    get { YGNodeStyleGetWidth(ref) }
    set {
      switch newValue.unit {
      case .point: YGNodeStyleSetWidth(ref, newValue.value)
      case .percent: YGNodeStyleSetWidthPercent(ref, newValue.value)
      case .auto: YGNodeStyleSetWidthAuto(ref)
      case .undefined: break
      @unknown default: break
      }
    }
  }

  public var height: Value {
    get { YGNodeStyleGetHeight(ref) }
    set {
      switch newValue.unit {
      case .point: YGNodeStyleSetHeight(ref, newValue.value)
      case .percent: YGNodeStyleSetHeightPercent(ref, newValue.value)
      case .auto: YGNodeStyleSetHeightAuto(ref)
      case .undefined: break
      @unknown default: break
      }
    }
  }

  public var minWidth: Value {
    get { YGNodeStyleGetMinWidth(ref) }
    set {
      switch newValue.unit {
      case .point: YGNodeStyleSetMinWidth(ref, newValue.value)
      case .percent: YGNodeStyleSetMinWidthPercent(ref, newValue.value)
      case .auto: break
      case .undefined: break
      @unknown default: break
      }
    }
  }

  public var minHeight: Value {
    get { YGNodeStyleGetMinHeight(ref) }
    set {
      switch newValue.unit {
      case .point: YGNodeStyleSetMinHeight(ref, newValue.value)
      case .percent: YGNodeStyleSetMinHeightPercent(ref, newValue.value)
      case .auto: break
      case .undefined: break
      @unknown default: break
      }
    }
  }


  public var maxWidth: Value {
    get { YGNodeStyleGetMaxWidth(ref) }
    set {
      switch newValue.unit {
      case .point: YGNodeStyleSetMaxWidth(ref, newValue.value)
      case .percent: YGNodeStyleSetMaxWidthPercent(ref, newValue.value)
      case .auto: break
      case .undefined: break
      @unknown default: break
      }
    }
  }

  public var maxHeight: Value {
    get { YGNodeStyleGetMaxHeight(ref) }
    set {
      switch newValue.unit {
      case .point: YGNodeStyleSetMaxHeight(ref, newValue.value)
      case .percent: YGNodeStyleSetMaxHeightPercent(ref, newValue.value)
      case .auto: break
      case .undefined: break
      @unknown default: break
      }
    }
  }

  public var aspectRatio: CGFloat {
    get { CGFloat(YGNodeStyleGetAspectRatio(ref)) }
    set { YGNodeStyleSetAspectRatio(ref, newValue.float) }
  }

}
