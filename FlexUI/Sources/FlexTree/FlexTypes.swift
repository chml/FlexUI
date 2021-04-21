//
//  YogaTypes.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/27.
//

import yoga

public typealias Align = YGAlign
public typealias Dimension = YGDimension
public typealias Direction = YGDirection
public typealias FlexDirection = YGFlexDirection
public typealias Justify = YGJustify
public typealias Unit = YGUnit
public typealias PositionType = YGPositionType
public typealias FlexWrap = YGWrap
public typealias MeasureMode = YGMeasureMode
public typealias Edge = YGEdge
public typealias NodeType = YGNodeType
public typealias Overflow = YGOverflow
public typealias Display = YGDisplay
public typealias Value = YGValue
extension Value {
  public static let auto       = Value(value: 0, unit: .auto)
  public static let undefined  = Value(value: 0, unit: .undefined)
  public static let zero       = Value(value: 0, unit: .point)
  public static func point(_ value: CGFloat) -> Value {
    return Value(value: value.float, unit: .point)
  }

  public static func percent(_ value: CGFloat) -> Value {
    return Value(value: value.float, unit: .percent)
  }
}
