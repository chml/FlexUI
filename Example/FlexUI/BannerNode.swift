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
      Image(.url(imageURL))
        .viewConfig({ (v) in
          v.contentMode = .scaleAspectFill
          v.layer.cornerRadius = 10
          v.layer.masksToBounds = true
          v.backgroundColor = .random
        })
        .width(.percent(90))
        .aspectRatio(16.0/9)
    }
    .width(.percent(100))
    .height(.percent(100))
    .asAnyNode
  }
}

final class SurroundLayout: UICollectionViewFlowLayout {
  override init() {
    super.init()
    minimumLineSpacing = 0
    minimumInteritemSpacing = 0
    scrollDirection = .horizontal
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    true
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let results = super.layoutAttributesForElements(in: rect)
    guard let bounds = collectionView?.bounds else {
      return results
    }
    results?.forEach({ attr in
      let scale: CGFloat = (1 - (abs(attr.frame.midX - bounds.midX)/(bounds.width)/2))
      attr.transform = .init(scaleX: scale, y: scale)
    })
    return results
  }
}

struct BannerNode: CoordinateNode {

  typealias Body = AnyNode

  let bannerImageURLs: [URL]
  @EqualableClosure var onSelect: (Int) -> Void

  var id: AnyHashable {
    "banners"
  }

  func isContentEqual(to other: BannerNode) -> Bool {
    bannerImageURLs == other.bannerImageURLs && $onSelect === other.$onSelect
  }

  private var layout: SurroundLayout {
    let ret = SurroundLayout()
//    ret.scrollDirection = .horizontal
//    ret.minimumInteritemSpacing = 0
//    ret.minimumLineSpacing = 0
//    ret.sectionInset = .zero
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
        v.transform = CGAffineTransform(scaleX: -1, y: 1)
        v.clipsToBounds = false
        coordinator.collectionView = v
      }
      .height(.percent(100))
    }
    .width(.percent(80))
    .aspectRatio(16.0/9)
    .asAnyNode
  }

  final class Coordinator: NodeCoordinator {
    var collectionView: UICollectionView!
    var timer: Timer? = nil

    deinit {
      timer?.invalidate()
    }

    override func didLoad() {
    }

    func startAutoScrolling() {
      guard let _ = collectionView else { return }
      timer?.invalidate()
//      timer = Timer(fire: Date(), interval: 3, repeats: true, block: { [weak self] (_) in
//      })
    }

  }

}
