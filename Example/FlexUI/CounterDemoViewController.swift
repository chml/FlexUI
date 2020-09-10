//
//  CounterDemoViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

private struct Counter: Component {
  typealias Body = AnyNode

  var count: Int

  func body(with coordinator: Coordinator) -> AnyNode {
    VStack(alignItems: .center) {
      Text("\(count)")
        .font(.preferredFont(forTextStyle: .headline))
        .viewConfig { (label) in
          label.backgroundColor = .gray
      }
      .padding(10)
      .flexGrow(1).flexShrink(1)
      HStack {
        Button("-100") {
          coordinator.update {
            $0.count -= 100
          }
        }
        Button("+100") {
          coordinator.update(animated: true) {
            $0.count += 100
          }
        }
      }
    }.asAnyNode
  }

}

final class CounterDemoViewController: UIViewController {

  var counter: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Counter"
    view.backgroundColor = .white
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    flex.render {
      VStack(justifyContent: .center, alignItems: .center) {
        Counter(count: self.counter)
          .onUpdated{ [weak self] in
            self?.counter = $0.count
          }
      }
      .width(.percent(100))
      .height(.percent(100))
    }
  }

}
