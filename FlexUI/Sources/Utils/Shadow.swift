//
//  Shadow.swift
//  FlexUI
//
//  Created by Li ChangMing on 2021/9/29.
//

public struct Shadow {
  public var alpha: Float = 1
  public var color: UIColor
  public var offset: CGPoint
  public var blur: CGFloat
  public var spread: CGFloat

  public init(color: UIColor, offset: CGPoint = .zero, blur: CGFloat = 0, spread: CGFloat = 0) {
    self.color = color
    self.offset = offset
    self.blur = blur
    self.spread = spread
  }
}
