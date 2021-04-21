//
//  UIViewUtils.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/31.
//

import UIKit

extension UIScrollView {

  var isScrolling: Bool {
    return isTracking || isDragging || isDecelerating
  }

  func setAdjustedContentOffsetIfNeeded(_ contentOffset: CGPoint) {
    let maxContentOffsetX = contentSize.width + availableContentInset.right - bounds.width
    let maxContentOffsetY = contentSize.height + availableContentInset.bottom - bounds.height
    let isContentRectContainsBounds = CGRect(origin: .zero, size: contentSize)
      .inset(by: availableContentInset.inverted)
      .contains(bounds)

    if isContentRectContainsBounds && !isScrolling {
      self.contentOffset = CGPoint(
        x: min(maxContentOffsetX, contentOffset.x),
        y: min(maxContentOffsetY, contentOffset.y)
      )
    }
  }

  private var availableContentInset: UIEdgeInsets {
    if #available(iOS 11.0, tvOS 11.0, *) {
      return adjustedContentInset
    }
    else {
      return contentInset
    }
  }

  func adjustContentSizeForSubviews() {
    if self is UITableView || self is UICollectionView {
      return
    }
    var size = bounds.size
    for v in subviews {
      size.width = max(size.width, v.frame.maxX)
      size.height = max(size.height, v.frame.maxY)
    }
    self.contentSize = size
    if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft && contentOffset.x == 0 {
      contentOffset = .init(x: size.width - bounds.width, y: contentOffset.y)
    }
  }

}

private extension UIEdgeInsets {
  var inverted: UIEdgeInsets {
    return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
  }
}
