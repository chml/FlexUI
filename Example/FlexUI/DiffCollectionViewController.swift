//
//  DiffCollectionViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

final class DiffCollectionViewController: UIViewController {

  var state: [Int] = [1, 2, 3] {
    didSet {
      render()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    render()
  }

  func render() {
    view.render(node: Flex {
      List(of: UICollectionView.self, data: state) { (i) in
        Text("Row \(i)")
          .textColor(.random)
          .padding(20)
      }
      .pullToRefresh({ [weak self] (endRefreshing) in
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
          self?.state = [4, 3, 2, 1]
        }
        endRefreshing()
      })
        .viewMaker({
          let v = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
          v.backgroundColor = .white
          return v
        })
        .viewConfig({ (view) in
        })
        .width(.percent(100))
        .height(.percent(100))
    })
  }

}
