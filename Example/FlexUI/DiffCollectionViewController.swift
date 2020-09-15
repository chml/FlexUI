//
//  DiffCollectionViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

final class DiffCollectionViewController: UIViewController, Component {

  typealias Body = AnyNode

  var state: [Int] = Array(0..<99)

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    flex.render()
  }

  func body(with coordinator: SimpleCoordinator<DiffCollectionViewController>) -> AnyNode {
    List(collection: UICollectionViewFlowLayout(), data: state) { (i) in
      Text("Row \(i)")
        .textColor(.random)
        .padding(20)
    }
    .pullToRefresh({ (endRefreshing) in
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        coordinator.update {
          $0.state.shuffle()
        }
      }
      endRefreshing()
    })
      .viewConfig({ (v) in
        v.backgroundColor = .white
      })
      .width(.percent(100))
      .height(.percent(100))
      .asAnyNode
  }

}
