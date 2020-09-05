//
//  DiffTableViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

final class DiffTableViewController: UIViewController {

  var state: [Int] = [1, 2, 3] {
    didSet {
      render()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }

  func render() {
    view.render(node: Flex {
      List(of: UITableView.self, data: state) { (i) in
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
      .width(.percent(100))
      .height(.percent(100))
      })
  }

}
