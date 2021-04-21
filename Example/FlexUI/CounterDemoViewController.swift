//
//  CounterDemoViewController.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

final class CounterDemoViewController: UIViewController, Component {

  typealias Body = AnyNode

  var fontSize: Int = 12

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Counter"
    view.backgroundColor = .white
    flex.render()
  }

  func body(with coordinator: SimpleCoordinator<CounterDemoViewController>) -> AnyNode {
    VStack(spacing: 20, justifyContent: .center, alignItems: .center) {
      Text("\(coordinator.content.fontSize)")
        .font(UIFont.boldSystemFont(ofSize: CGFloat(coordinator.content.fontSize)))
        .padding(UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
        .viewConfig { (label) in
          label.backgroundColor = .gray
        }
      HStack(spacing: 20) {
        Button("-1") {
          coordinator.update(animated: true) {
            $0.fontSize -= 1
          }
        }
        .viewReuseID("-")
        Button("+1") {
          coordinator.update(animated: true) {
            $0.fontSize += 1
          }
        }
        .viewReuseID("+")
      }
    }
    .width(.percent(100))
    .height(.percent(100))
    .asAnyNode
  }


}
