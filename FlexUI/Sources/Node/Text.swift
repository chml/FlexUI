//
//  Text.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/28.
//

import MPITextKit

public struct Text: Node, ViewProducible {
  public typealias Body = Never
  public typealias ProductedView = MPILabel

  public struct StringAttributes {
    public let string: NSAttributedString
    public let numberOfLines: Int

    public init(_ string: NSAttributedString, numberOfLines: Int = 0) {
      self.string = string
      self.numberOfLines = numberOfLines
    }
    public init(_ string: String, font: UIFont = .preferredFont(forTextStyle: .body), color: UIColor = .darkText, numberOfLines: Int = 0) {
      self.init(NSAttributedString(string: string, attributes: [ .font: font, .foregroundColor: color ]), numberOfLines: numberOfLines)
    }
  }

  let stringAttributes: StringAttributes

  public init(_ stringAttributes: StringAttributes) {
    self.stringAttributes = stringAttributes
  }

}


extension Text {
  public init(_ string: NSAttributedString, numberOfLines: Int = 0) {
    self.init(.init(string, numberOfLines: numberOfLines))
  }

  public init(_ string: String, font: UIFont = .preferredFont(forTextStyle: .body), color: UIColor = .darkText, numberOfLines: Int = 0) {
    self.init(.init(string, font: font, color: color, numberOfLines: numberOfLines))
  }
}


extension Text {
  public func build(with context: YogaTreeContext) -> [YogaNode] {
    let yogaNode = YogaNode()
    let viewProducer = ViewProducer(type: ProductedView.self)
    yogaNode.measureFunc = { (node, width, widthMode, height, heightMode) in
      let attrBuilder = MPITextRenderAttributesBuilder()
      attrBuilder.attributedText = self.stringAttributes.string
      attrBuilder.maximumNumberOfLines = UInt(self.stringAttributes.numberOfLines)
      let attr = MPITextRenderAttributes(builder: attrBuilder)
      let fitSize = CGSize(width: width, height: height).normalized
      let size = MPITextSuggestFrameSizeForAttributes(attr, fitSize, .zero)
      return size
    }
    viewProducer.appendConfiguration(as: ProductedView.self) { [weak yogaNode] label in
      let padding = yogaNode?.style.paddingInsets() ?? .zero
      label.textContainerInset = padding
      label.attributedText = self.stringAttributes.string
      label.numberOfLines = self.stringAttributes.numberOfLines
    }
    yogaNode.viewProducer = viewProducer
    return [yogaNode]
  }
}
