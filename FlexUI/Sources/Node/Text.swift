//
//  Text.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/28.
//

import MPITextKit
import UIKit

public struct Text: Node, ViewProducible {
  public typealias Body = Never
  public typealias ProductedView = MPILabel

  enum Storage {
    case verbatim(String)
    case attributed(NSAttributedString)
  }

  enum Modifier {
    case numberOfLines(Int)
    case textAlignment(NSTextAlignment)
    case textColor(UIColor)
    case font(UIFont)
  }
  let storage: Storage
  let modifiers: [Modifier]

  var attributedString: NSAttributedString  {
    switch storage {
    case .attributed(let str):
      return str
    case .verbatim(let str):
      var attr: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .body),
                                                 .foregroundColor: UIColor.darkText]
      for modeifier in modifiers {
        switch modeifier {
        case .numberOfLines: break
        case .textAlignment: break
        case .textColor(let color):
          attr[.foregroundColor] = color
        case .font(let font):
          attr[.font] = font
        }
      }

      return NSAttributedString(string: str, attributes: attr)
    }
  }

  init(storage: Storage, modifiers: [Modifier] = []) {
    self.storage = storage
    self.modifiers = modifiers
  }
}

extension Text {
  public init(_ string: NSAttributedString) {
    self.init(storage: .attributed(string))
  }

  public init(_ string: String) {
    self.init(storage: .verbatim(string))
  }
}

extension Text {

  private func with(modifier: Modifier) -> Text {
    var modifiers = self.modifiers
    modifiers.append(modifier)
    return Text(storage: storage, modifiers: modifiers)
  }

  public func numberOfLines(_ lines: Int) -> Text {
    with(modifier: .numberOfLines(lines))
  }

  public func textAlignment(_ align: NSTextAlignment) -> Text {
    with(modifier: .textAlignment(align))
  }

  public func textColor(_ color: UIColor) -> Text {
    with(modifier: .textColor(color))
  }

  public func font(_ font: UIFont) -> Text {
    with(modifier: .font(font))
  }

}


extension Text {
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let flexNode = FlexNode()
    flexNode.nodeType = .text
    let viewProducer = TextViewProducer(type: ProductedView.self)
    flexNode.measureFunc = {  (node, width, widthMode, height, heightMode) in
      let attrStr = NSMutableAttributedString(attributedString: self.attributedString)
      let attrBuilder = MPITextRenderAttributesBuilder()
      attrBuilder.maximumNumberOfLines = 0
      for modifier in self.modifiers {
        switch modifier {
        case .numberOfLines(let lines):
          attrBuilder.maximumNumberOfLines = UInt(lines)
        case .textAlignment(let alignment):
          attrStr.mpi_setAlignment(alignment, range: .init(location: 0, length: attrStr.length))
        case .textColor: break
        case .font: break
        }
      }
      attrBuilder.attributedText = attrStr
      let attr = MPITextRenderAttributes(builder: attrBuilder)
      let renderer = MPITextRenderer(renderAttributes: attr,
                                     constrainedSize: CGSize(width: widthMode == .undefined ? .greatestFiniteMagnitude : width,
                                                             height: heightMode == .undefined ? .greatestFiniteMagnitude : height))
      viewProducer.textRenderer = renderer
      var size = renderer.size()
      size.width = ceil(size.width)
      size.height = ceil(size.height)
      return size
    }
    
    viewProducer.appendViewConfig(as: ProductedView.self) { [weak flexNode] label in
      let padding = flexNode?.style.paddingInsets() ?? .zero
      label.textContainerInset = padding
      if let viewProducer = flexNode?.viewProducer as? TextViewProducer {
        label.textRenderer = viewProducer.textRenderer
      }
    }
    flexNode.viewProducer = viewProducer
    return [flexNode]
  }
}

private final class TextViewProducer: ViewProducer {
  var textRenderer: MPITextRenderer? = nil
}
