//
//  Button.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/8.
//

import UIKit
import MPITextKit
import Nuke


public struct Button: Node, ViewProducible {
  public typealias Body = Never
  public typealias ProductedView = UIButton

  public enum ButtonType {
    case system(title: String)
    case custom(image: UIImage? = nil, imageURL: URL? = nil, title: String? = nil, font: UIFont? = nil)
    case detailDisclosure
    case infoLight
    case infoDark
    case contactAdd
  }

  let type: ButtonType
  let action: () -> Void

  public init(_ type: ButtonType, action: @escaping () -> Void) {
    self.type = type
    self.action = action
  }

  public init(_ title: String, action:  @escaping () -> Void) {
    self.init(.system(title: title), action: action)
  }

}

extension Button {

  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let flexNode = FlexNode()
    let viewProducer = ViewProducer(type: ProductedView.self)
    flexNode.viewProducer = viewProducer
    let buttonType: UIButton.ButtonType// = .system
    let size: CGSize
    switch self.type {
    case .system(let title):
      buttonType = .system
      let attrBuilder = MPITextRenderAttributesBuilder()
      attrBuilder.attributedText = NSAttributedString(string: title, attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
      let attr = MPITextRenderAttributes(builder: attrBuilder)
      let titleSize = MPITextSuggestFrameSizeForAttributes(attr, CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), UIEdgeInsets(top: 6, left: 2, bottom: 6, right: 2))
      size = titleSize
      viewProducer.appendConfiguration(as: ProductedView.self) { (v) in
        v.setTitle(title, for: .normal)
      }
    case .custom(let image, let url, let title, let font):
      buttonType = .custom
      var totalSize: CGSize = .zero
      if let image = image {
        totalSize = image.size
      }
      if let title = title {
        let attrBuilder = MPITextRenderAttributesBuilder()
        attrBuilder.attributedText = NSAttributedString(string: title, attributes: [.font: font ?? UIFont.boldSystemFont(ofSize: 15)])
        let attr = MPITextRenderAttributes(builder: attrBuilder)
        let titleSize = MPITextSuggestFrameSizeForAttributes(attr, CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), UIEdgeInsets(top: 6, left: 2, bottom: 6, right: 2))
        totalSize.height = max(totalSize.height, titleSize.height)
        totalSize.width += (titleSize.width + 8)
      }

      size = totalSize
      viewProducer.appendConfiguration(as: ProductedView.self) { (v) in
        if let font = font {
          v.titleLabel?.font = font
        }
        v.setTitle(title, for: .normal)
        if let image = image {
          v.setImage(image, for: .normal)
        }
        if let url = url {
          Nuke.loadImage(with: url, into: v)
        }
      }
    case .detailDisclosure:
      buttonType = .detailDisclosure
      size = CGSize(width: 25, height: 25)
    case .infoLight:
      buttonType = .infoLight
      size = CGSize(width: 25, height: 25)
    case .infoDark:
      buttonType = .infoDark
      size = CGSize(width: 25, height: 25)
    case .contactAdd:
      buttonType = .contactAdd
      size = CGSize(width: 25, height: 25)
    }
    viewProducer.appendConfiguration(as: ProductedView.self) {
      $0.flex.action = self.action
    }
    viewProducer.viewMaker = { UIButton(type: buttonType) }
    if size.width > 0 {
      flexNode.style.width = .point(size.width)
    }
    if size.height > 0 {
      flexNode.style.height = .point(size.height)
    }
    return [flexNode]
  }


}


extension UIButton: Nuke_ImageDisplaying {
  @objc open func nuke_display(image: PlatformImage?) {
    guard image != nil else {
//      self.animatedImage = nil
//      self.image = nil
      self.setImage(nil, for: .normal)
      return
    }
    if let _ = image?.animatedImageData {
      // Display poster image immediately
      self.setImage(image, for: .normal)

      // Prepare FLAnimatedImage object asynchronously (it takes a
      // noticeable amount of time), and start playback.
      DispatchQueue.global().async {
//        let animatedImage = FLAnimatedImage(animatedGIFData: data)
        DispatchQueue.main.async {
          // If view is still displaying the same image
          if self.imageView?.image === image {
//            self.animatedImage = animatedImage
          }
        }
      }
    } else {
//      self.image = image
      self.setImage(image, for: .normal)
    }
  }
}
