//
//  InfiniteScollFooter.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/17.
//

import UIKit

public final class InfiniteScrollFooter: UIView {

  let triggerDistance: CGFloat = 300
  var offsetObseration: NSKeyValueObservation? = nil
  lazy var loadingView: UIActivityIndicatorView = {
    let v = UIActivityIndicatorView()
    addSubview(v)
    return v
  } ()

  weak var scrollView: UIScrollView? = nil {
    didSet {
      offsetObseration?.invalidate()
      offsetObseration = scrollView?.observe(\.contentOffset, changeHandler: { [weak self] (view, value) in
        guard let self = self,
              self.isLoading == false,
              let action = self.action
        else {
          return
        }
        let offset = view.contentOffset
        let bounds = view.bounds
        let contentSize = view.contentSize
        let distance = contentSize.height - offset.y - bounds.height
        if distance < 0 || distance > self.triggerDistance {
          return
        }
        self.isLoading = true
        action ({ isAllLoaded in
          self.isLoading = false
        })

      })
    }
  }

  var isLoading: Bool = false {
    didSet {
      setNeedsLayout()
    }
  }
  var action: ((_ endRefreshing: @escaping (_ isAllLoaded: Bool) -> Void) -> Void)? = nil

  public override func layoutSubviews() {
    super.layoutSubviews()
    loadingView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    if isLoading {
      loadingView.startAnimating()
    } else {
      loadingView.stopAnimating()
    }
  }

  func adjustFrame(for scrollView: UIScrollView) {
    frame = CGRect(x: 0, y: max(scrollView.contentSize.height, scrollView.bounds.height), width: scrollView.bounds.width, height: 50)
    var inset = scrollView.contentInset
    inset.bottom = frame.height
    scrollView.contentInset = inset
    setNeedsLayout()
  }
}

private struct Keys {
  static var infiniteScrollFooter: Int8 = 0
}

extension UIScrollView {
  public var infiniteScrollFooter: InfiniteScrollFooter {
    get {
      if let footer = objc_getAssociatedObject(self, &Keys.infiniteScrollFooter) as? InfiniteScrollFooter {
        footer.adjustFrame(for: self)
        return footer
      }
      let footer = InfiniteScrollFooter()
      footer.adjustFrame(for: self)
      addSubview(footer)
      objc_setAssociatedObject(self, &Keys.infiniteScrollFooter, footer, .OBJC_ASSOCIATION_RETAIN)
      footer.scrollView = self
      return footer
    }
  }
}
