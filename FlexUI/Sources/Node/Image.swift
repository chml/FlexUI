//
//  Image.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/28.
//

import Nuke
import FLAnimatedImage

public struct Image: Node, ViewProducible {
  public typealias ProductedView = FLAnimatedImageView
  public typealias Body = Never
  public enum Source {
    case image(image: UIImage?)
    case url(url: URL?, placeholder: UIImage? = nil)
  }
  public let source: Source

  public init(_ source: Source) {
    self.source = source
  }

  public init(_ image: UIImage?) {
    self.init(.image(image: image))
  }

  public init(_ url: URL?, placeholder: UIImage? = nil) {
    self.init(.url(url: url, placeholder: placeholder))
  }

}


extension Image {
  public func build(with context: FlexTreeContext) -> [FlexNode] {
    let yogaNode = FlexNode()
    let viewProducer = ViewProducer(type: ProductedView.self)
    yogaNode.viewProducer = viewProducer
    switch source {
    case .image(let image):
      if let size = image?.size {
        yogaNode.style.width = .point(size.width)
        yogaNode.style.height = .point(size.height)
      }
      viewProducer.appendConfiguration(as: ProductedView.self) { view in
        view.image = image
      }
    case .url(let url, let placehoder):
      viewProducer.appendConfiguration(as: ProductedView.self) { (view) in
        view.image = placehoder
        if let url = url {
          Nuke.loadImage(with: url, into: view)
        }
      }
    }
    return [yogaNode]
  }
}

extension FLAnimatedImageView {
  @objc open override func nuke_display(image: PlatformImage?) {
    guard image != nil else {
      self.animatedImage = nil
      self.image = nil
      return
    }
    if let data = image?.animatedImageData {
      // Display poster image immediately
      self.image = image

      // Prepare FLAnimatedImage object asynchronously (it takes a
      // noticeable amount of time), and start playback.
      DispatchQueue.global().async {
        let animatedImage = FLAnimatedImage(animatedGIFData: data)
        DispatchQueue.main.async {
          // If view is still displaying the same image
          if self.image === image {
            self.animatedImage = animatedImage
          }
        }
      }
    } else {
      self.image = image
    }
  }
}
