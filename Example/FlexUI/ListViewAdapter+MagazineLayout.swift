//
//  ListViewAdapter+MagazineLayout.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/18.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI
import MagazineLayout

extension ListViewAdapter: UICollectionViewDelegateMagazineLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeModeForItemAt indexPath: IndexPath)
    -> MagazineLayoutItemSizeMode
  {
    guard let delegate = customLayoutInfo as? UICollectionViewDelegateMagazineLayout else {
      fatalError()
    }
    let mode = delegate.collectionView(collectionView, layout: collectionViewLayout, sizeModeForItemAt: indexPath)
    if isStaticLayout {
      if let tree = staticLayoutStorage[indexPath.section]?[indexPath.item] {
        return .init(widthMode: mode.widthMode, heightMode: .static(height: tree.layout?.contentSize.height ?? 0))
      }
    } else {
      if let tree = dynamicLayoutStorage[data[indexPath.section].cells[indexPath.item]] {
        return .init(widthMode: mode.widthMode, heightMode: .static(height: tree.layout?.contentSize.height ?? 0))
      }
    }
    return mode
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    visibilityModeForHeaderInSectionAtIndex index: Int)
    -> MagazineLayoutHeaderVisibilityMode
  {
    guard let delegate = customLayoutInfo as? UICollectionViewDelegateMagazineLayout else {
      fatalError()
    }
    return delegate.collectionView(collectionView, layout: collectionViewLayout, visibilityModeForHeaderInSectionAtIndex: index)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    visibilityModeForFooterInSectionAtIndex index: Int)
    -> MagazineLayoutFooterVisibilityMode
  {
    guard let delegate = customLayoutInfo as? UICollectionViewDelegateMagazineLayout else {
      fatalError()
    }
    return delegate.collectionView(collectionView, layout: collectionViewLayout, visibilityModeForFooterInSectionAtIndex: index)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    visibilityModeForBackgroundInSectionAtIndex index: Int)
    -> MagazineLayoutBackgroundVisibilityMode
  {
    guard let delegate = customLayoutInfo as? UICollectionViewDelegateMagazineLayout else {
      fatalError()
    }
    return delegate.collectionView(collectionView, layout: collectionViewLayout, visibilityModeForBackgroundInSectionAtIndex: index)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    horizontalSpacingForItemsInSectionAtIndex index: Int)
    -> CGFloat
  {
    guard let delegate = customLayoutInfo as? UICollectionViewDelegateMagazineLayout else {
      return 0
    }
    return delegate.collectionView(collectionView, layout: collectionViewLayout, horizontalSpacingForItemsInSectionAtIndex: index)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    verticalSpacingForElementsInSectionAtIndex index: Int)
    -> CGFloat
  {
    guard let delegate = customLayoutInfo as? UICollectionViewDelegateMagazineLayout else {
      return 0
    }
    return delegate.collectionView(collectionView, layout: collectionViewLayout, verticalSpacingForElementsInSectionAtIndex: index)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetsForSectionAtIndex index: Int)
    -> UIEdgeInsets
  {
    guard let delegate = customLayoutInfo as? UICollectionViewDelegateMagazineLayout else {
      return .zero
    }
    return delegate.collectionView(collectionView, layout: collectionViewLayout, insetsForSectionAtIndex: index)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetsForItemsInSectionAtIndex index: Int)
    -> UIEdgeInsets
  {
    guard let delegate = customLayoutInfo as? UICollectionViewDelegateMagazineLayout else {
      return .zero
    }
    return delegate.collectionView(collectionView, layout: collectionViewLayout, insetsForItemsInSectionAtIndex: index)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    finalLayoutAttributesForRemovedItemAt indexPath: IndexPath,
    byModifying finalLayoutAttributes: UICollectionViewLayoutAttributes)
  {
    guard let delegate = customLayoutInfo as? UICollectionViewDelegateMagazineLayout else {
      return
    }
    delegate.collectionView(collectionView, layout: collectionViewLayout, finalLayoutAttributesForRemovedItemAt: indexPath, byModifying: finalLayoutAttributes)
  }

}
