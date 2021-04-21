//
//  Text.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/28.
//

import MPITextKit

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
      modifiers.forEach {
        switch $0 {
        case .font(let font):
          attr[.font] = font
        case .textColor(let color):
          attr[.foregroundColor] = color
        default: break
        }
      }
      return NSAttributedString(string: str, attributes: attr)
    }
  }

  var numberOfLines: Int {
    for modifier in modifiers {
      switch modifier {
      case .numberOfLines(let lines): return lines
      default: break
      }
    }
    return 0
  }

  init(storage: Storage, modifiers: [Modifier]) {
    self.storage = storage
    self.modifiers = modifiers
  }
}

extension Text {
  public init(_ string: NSAttributedString) {
    self.init(storage: .attributed(string), modifiers: [])
  }

  public init(_ string: String) {
    self.init(storage: .verbatim(string), modifiers: [])
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
    let yogaNode = FlexNode()
    let viewProducer = ViewProducer(type: ProductedView.self)
    yogaNode.measureFunc = { (node, width, widthMode, height, heightMode) in
      let attrBuilder = MPITextRenderAttributesBuilder()
      attrBuilder.attributedText = self.attributedString
      attrBuilder.maximumNumberOfLines = UInt(self.numberOfLines)
      let attr = MPITextRenderAttributes(builder: attrBuilder)
      let fitSize = CGSize(width: width, height: height).normalized
      var size = MPITextSuggestFrameSizeForAttributes(attr, fitSize, .zero)
      size.width = ceil(size.width)
      size.height = ceil(size.height)
      return size
    }
    viewProducer.appendConfiguration(as: ProductedView.self) { [weak yogaNode] label in
      let padding = yogaNode?.style.paddingInsets() ?? .zero
      label.textContainerInset = padding
      label.numberOfLines = 0
      for modifier in self.modifiers {
        switch modifier {
        case .numberOfLines(let lines):
          label.numberOfLines = lines
        case .textAlignment(let align):
          label.textAlignment = align
        default: break
        }
      }
      label.attributedText = self.attributedString
    }
    yogaNode.viewProducer = viewProducer
    return [yogaNode]
  }
}
