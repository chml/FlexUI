//
//  DiffTableViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI


fileprivate struct Cell: Node, Hashable {
  let text: String

  var body: AnyNode {
    Text(text)
      .textColor(.random)
      .padding(20)
      .asAnyNode
  }
}

final class DiffTableViewController: UIViewController, Component {
  typealias Body = AnyNode

  var state: [Int] = Array(0..<20)

  override func viewDidLoad() {
    super.viewDidLoad()
    flex.render()
  }

  func body(with coordinator: SimpleCoordinator<DiffTableViewController>) -> AnyNode {
    List(table: .grouped, data: state) { (i) in
      Cell(text:  i%2 == 1 ? "Row \(i)\nThat's odd?" : "Row \(i)")
    }
    .pullToRefresh { (endRefreshing) in
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        endRefreshing()
        coordinator.update {
          $0.state.shuffle()
        }
      }
    }
    .infiniteScroll({ (endRefreshing) in
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        coordinator.update {
          let count = $0.state.count
          if count > 200 {
            endRefreshing(true)
          } else {
            $0.state.append(contentsOf: (count..<20+count))
            endRefreshing(false)
          }
        }
      }
    })
    .width(.percent(100))
    .height(.percent(100))
    .asAnyNode
  }


}
