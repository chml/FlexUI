//
//  BannerNode.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/23.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

struct BannerCell: Node, Hashable {
  let imageURL: URL

  var body: AnyNode {
    VStack(justifyContent: .spaceAround, alignItems: .center) {
      Image(imageURL)
        .viewConfig({ (v) in
          v.contentMode = .scaleAspectFill
          v.layer.cornerRadius = 10
          v.layer.masksToBounds = true
        })
        .width(.percent(95))
        .aspectRatio(16.0/9)
    }
    .width(.percent(100))
    .height(.percent(100))
    .asAnyNode
  }
}

struct BannerNode: Component {
  typealias Body = AnyNode

  let bannerImageURLs: [URL]
  @EqualableClosure var onSelect: (Int) -> Void

  var id: AnyHashable {
    "banners"
  }

  func isContentEqual(to other: BannerNode) -> Bool {
    bannerImageURLs == other.bannerImageURLs && $onSelect === other.$onSelect
  }

  private var layout: UICollectionViewFlowLayout {
    let ret = UICollectionViewFlowLayout()
    ret.scrollDirection = .horizontal
    ret.minimumInteritemSpacing = 0
    ret.minimumLineSpacing = 0
    ret.sectionInset = .zero
    return ret
  }

  func body(with coordinator: Coordinator) -> AnyNode {
    VStack(alignItems: .stretch) {
      List(collection: layout, data: bannerImageURLs) {
        BannerCell(imageURL: $0)
      }
      .onSelect { (_, indexPath) in
        self.onSelect(indexPath.item)
      }
      .viewConfig { (v) in
        v.isPagingEnabled = true
        v.backgroundColor = .white
        coordinator.collectionView = v
      }
      .height(.percent(100))
    }
    .width(.percent(100))
    .aspectRatio(16.0/9)
    .asAnyNode
  }

  final class Coordinator: ComponentCoordinator {
    typealias Content = BannerNode
    let context: Context
    var collectionView: UICollectionView? = nil {
      didSet {
        startAutoScrolling()
      }
    }
    var timer: Timer? = nil

    deinit {
      timer?.invalidate()
    }

    required init(with context: Context) {
      self.context = context
    }

    func startAutoScrolling() {
      guard let _ = collectionView else { return }
      timer?.invalidate()
      timer = Timer(fire: Date(), interval: 3, repeats: true, block: { [weak self] (_) in
      })
    }

  }

}
