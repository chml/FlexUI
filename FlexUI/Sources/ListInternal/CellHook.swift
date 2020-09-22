//
//  CellHook.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/18.
//

import UIKit


extension UITableViewCell {
  @objc static func _flexSwiftLoad() {
    if let m1 = class_getInstanceMethod(self, #selector(setHighlighted(_:animated:))),
       let m2 = class_getInstanceMethod(self, #selector(UITableViewCell._hooked_setHighlighted(_:animated:))) {
      method_exchangeImplementations(m1, m2)
    }
  }

  @objc
  func _hooked_setHighlighted(_ highlighted: Bool, animated: Bool) {
    self._hooked_setHighlighted(highlighted, animated: animated)
    if let tree = contentView.flex.tree {
      if let coordinator = tree.node.findFirstCoodinator() {
        coordinator.setHighlighted(highlighted, animated: animated)
      }
    }
  }
}

extension UICollectionViewCell {
  @objc static func _flexSwiftLoad() {
    if let m1 = class_getInstanceMethod(self, #selector(setter: UICollectionViewCell.isHighlighted)),
       let m2 = class_getInstanceMethod(self, #selector(UICollectionViewCell._hooked_setHighlighted(_:))) {
      method_exchangeImplementations(m1, m2)
    }
  }

  @objc
  func _hooked_setHighlighted(_ highlighted: Bool) {
    self._hooked_setHighlighted(highlighted)
    if let tree = contentView.flex.tree {
      if let coordinator = tree.node.findFirstCoodinator() {
        coordinator.setHighlighted(highlighted, animated: true)
      }
    }
  }
}
