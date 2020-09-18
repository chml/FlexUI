//
//  MagazineLayoutViewController.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/18.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI
import MagazineLayout

struct LiveRoomFullWidthCell: Node, Hashable {
  let room: LiveRoom
  let widthPercent: CGFloat
  var id: AnyHashable { return room.id }

  var body: AnyNode {
    HStack(spacing: 12) {
      Image(room.imageURL)
        .aspectRatio(1)
        .width(100)
      VStack(spacing: 8) {
        Text(room.title)
          .flexGrow(1).flexShrink(1)
        Text(room.host)
          .font(.preferredFont(forTextStyle: .subheadline))
          .textColor(.lightGray)
          .flexGrow(1).flexShrink(1)
      }
      .flexGrow(1).flexShrink(1)
    }
    .padding(of: .vertical, 12)
    .flexGrow(1).flexShrink(1)
    .width(.percent(widthPercent))
    .asAnyNode
  }
}

final class MagazineLayoutViewController: UIViewController, Component {

  typealias Body = AnyNode

  fileprivate var online: [LiveRoom] = LiveRoom.generate(0, count: 21)
  fileprivate var offline: [LiveRoom] = LiveRoom.generate(100, count: 20)
  let layout = MagazineLayout()
  let horizontalPadding: CGFloat = 12
  let horizontalSpacing: CGFloat = 12
  let verticalSpacing: CGFloat = 12
  var halfWidthItemWidthPercent: CGFloat {
    let width = view.bounds.width
    return floor((width - horizontalPadding*2 - horizontalSpacing)/2/width * 100)
  }

  var fullWidthItemWidthPercent: CGFloat {
    let width = view.bounds.width
    return floor((width - horizontalPadding*2)/width * 100)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    flex.render()
  }

  func body(with coordinator: SimpleCoordinator<MagazineLayoutViewController>) -> AnyNode {
    List(collection: layout, data: [("Online", online), ("Offline", offline)]) { data in
      Section(id: data.0, header: LiveRoomHeader(id: data.0, text: data.0)) {
        if data.0 == "Online" {
          ForEach(data.1) {
            LiveRoomCell(room: $0, widthPercent: self.halfWidthItemWidthPercent)
          }
        } else {
          ForEach(data.1) {
            LiveRoomFullWidthCell(room: $0, widthPercent: self.fullWidthItemWidthPercent)
          }
        }
      }
    }
    .customCellClass(MagazineLayoutCollectionViewCell.self)
    .customReusableViewClass(MagazineLayoutCollectionReusableView.self)
    .customLayoutInfo(self)
    .sectionHeaderKind(MagazineLayout.SupplementaryViewKind.sectionHeader)
    .onSelect({[weak self] (item) in
      if let cell = item.unwrap(as: LiveRoomCell.self) {
        print("\(cell.room)")
        self?.navigationController?.pushViewController(LiveRoomViewController(), animated: true)
      }
    })
    .viewConfig({ (v) in
      v.backgroundColor = .white
    })
    .width(.percent(100))
    .height(.percent(100))
    .asAnyNode
  }

}


extension MagazineLayoutViewController: UICollectionViewDelegateMagazineLayout {

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeModeForItemAt indexPath: IndexPath)
    -> MagazineLayoutItemSizeMode
  {
    if indexPath.section == 0 {
      return .init(widthMode: .halfWidth, heightMode: .dynamic)
    } else {
      return .init(widthMode: .fullWidth(respectsHorizontalInsets: true), heightMode: .dynamic)
    }
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    visibilityModeForHeaderInSectionAtIndex index: Int)
    -> MagazineLayoutHeaderVisibilityMode
  {
    return .visible(heightMode: .dynamic)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    visibilityModeForFooterInSectionAtIndex index: Int)
    -> MagazineLayoutFooterVisibilityMode
  {
    return .hidden
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    visibilityModeForBackgroundInSectionAtIndex index: Int)
    -> MagazineLayoutBackgroundVisibilityMode
  {
    return .hidden
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    horizontalSpacingForItemsInSectionAtIndex index: Int)
    -> CGFloat
  {
    return horizontalSpacing
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    verticalSpacingForElementsInSectionAtIndex index: Int)
    -> CGFloat
  {
    return verticalSpacing
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetsForSectionAtIndex index: Int)
    -> UIEdgeInsets
  {
    return UIEdgeInsets(top: 24, left: horizontalPadding, bottom: 24, right: horizontalPadding)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetsForItemsInSectionAtIndex index: Int)
    -> UIEdgeInsets
  {
    return .zero
//    return UIEdgeInsets(top: 24, left: 4, bottom: 24, right: 4)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    finalLayoutAttributesForRemovedItemAt indexPath: IndexPath,
    byModifying finalLayoutAttributes: UICollectionViewLayoutAttributes)
  {
    // Fade and drop out
    finalLayoutAttributes.alpha = 0
    finalLayoutAttributes.transform = .init(scaleX: 0.2, y: 0.2)
  }
}
