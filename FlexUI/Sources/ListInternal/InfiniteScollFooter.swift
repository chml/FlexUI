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
  var contentSizeObseration: NSKeyValueObservation? = nil
  lazy var loadingView: UIActivityIndicatorView = {
    let v = UIActivityIndicatorView()
    addSubview(v)
    return v
  } ()

  weak var scrollView: UIScrollView? = nil {
    didSet {
      contentSizeObseration?.invalidate()
      offsetObseration?.invalidate()

      contentSizeObseration = scrollView?.observe(\.contentSize, changeHandler: { [weak self] (view, _) in
        guard let self = self else { return }
        self.frame = CGRect(x: 0, y: max(view.contentSize.height, view.bounds.height), width: view.bounds.width, height: 50)
        var inset = view.contentInset
        inset.bottom = self.frame.height
        view.contentInset = inset
        self.setNeedsLayout()
      })

      offsetObseration = scrollView?.observe(\.contentOffset, changeHandler: { [weak self] (view, _) in
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
    loadingView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    if isLoading {
      loadingView.startAnimating()
    } else {
      loadingView.stopAnimating()
    }
  }

}

private struct Keys {
  static var infiniteScrollFooter: Int8 = 0
}

extension UIScrollView {
  public var infiniteScrollFooter: InfiniteScrollFooter {
    get {
      if let footer = objc_getAssociatedObject(self, &Keys.infiniteScrollFooter) as? InfiniteScrollFooter {
        footer.setNeedsLayout()
        return footer
      }
      let footer = InfiniteScrollFooter()
      footer.scrollView = self
      addSubview(footer)
      objc_setAssociatedObject(self, &Keys.infiniteScrollFooter, footer, .OBJC_ASSOCIATION_RETAIN)
      return footer
    }
  }
}
