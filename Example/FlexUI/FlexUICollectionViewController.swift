//
//  FlexUICollectionViewController.swift
//  LayoutFrameworkBenchmark
//
//  Created by Li ChangMing on 2020/9/15.
//

import UIKit
import FlexUI

struct FeedItemData {

  let actionText: String
  let posterName: String
  let posterHeadline: String
  let posterTimestamp: String
  let posterComment: String
  let contentTitle: String
  let contentDomain: String
  let actorComment: String

  static func generate(count: Int) -> [FeedItemData] {
    var datas = [FeedItemData]()
    for i in 0..<count {
      let data = FeedItemData(
        actionText: "action text \(i)",
        posterName: "poster name \(i)",
        posterHeadline: "poster title \(i) with some longer stuff",
        posterTimestamp: "poster timestamp \(i)",
        posterComment: "poster comment \(i)",
        contentTitle: "content title \(i)",
        contentDomain: "content domain \(i)",
        actorComment: "actor comment \(i)"
      )
      datas.append(data)
    }
    return datas
  }
}

final class FlexUICollectionViewController: UIViewController {

  let data: [FeedItemData]

  init(data: [FeedItemData]) {
    self.data = data
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    flex.render {
      List(collection: UICollectionViewFlowLayout(), data: self.data) { item in
        FLFeedItemNode(data: item)
      }
      .viewConfig({ (v) in
        v.backgroundColor = .white
      })
        .width(.percent(100))
        .height(.percent(100))
    }
  }

}
