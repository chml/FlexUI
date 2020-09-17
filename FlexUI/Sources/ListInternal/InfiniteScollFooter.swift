//
//  InfiniteScollFooter.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/17.
//

import UIKit

final class InfiniteScrollFooter: UIView {

  var loading: Bool = false {
    didSet {
      setNeedsLayout()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    flex.render(
      VStack(alignItems: .center) {
        View(of: UIActivityIndicatorView.self)
          .width(30)
          .height(30)
          .padding(10)
          .viewConfig { [weak self] (v) in
            guard let self = self else { return }
            if self.loading {
              v.startAnimating()
            } else {
              v.stopAnimating()
            }
        }
      }
    )
  }

  func adjustFrame(for scrollView: UIScrollView) {
    frame = CGRect(x: 0, y: max(scrollView.contentSize.height, scrollView.bounds.height), width: scrollView.bounds.width, height: 50)
    setNeedsLayout()
  }
}

private struct Keys {
  static var infiniteScrollFooter: Int8 = 0
}

extension UIScrollView {
  var infiniteScrollFooter: InfiniteScrollFooter? {
    get {
      if let footer = objc_getAssociatedObject(self, &Keys.infiniteScrollFooter) as? InfiniteScrollFooter {
        footer.adjustFrame(for: self)
        return footer
      }
      let footer = InfiniteScrollFooter()
      footer.adjustFrame(for: self)
      addSubview(footer)
      objc_setAssociatedObject(self, &Keys.infiniteScrollFooter, footer, .OBJC_ASSOCIATION_RETAIN)
      return footer
    }
  }
}
