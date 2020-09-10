//
//  NodeViewViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/8.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

private struct Header: Component {
  typealias Body = AnyNode
  var toggle = false
  var text: String

  func body(with coordinator: Coordinator) -> AnyNode {
    VStack(spacing: 10, alignItems: .stretch) {
      Image(UIImage(systemName: "trash.fill")).width(40).height(40)
        .viewReuseID(1)
        .viewConfig {
          $0.backgroundColor = .red
      }
      .alignSelf(!toggle ? .flexStart : .flexEnd)
      Image(URL(string:"https://s3.ifanr.com/wp-content/uploads/2020/09/3090.png!720")).width(40).height(40)
        .viewReuseID(2)
        .viewConfig {
          $0.backgroundColor = .green
      }
      .alignSelf(toggle ? .flexStart : .flexEnd)
      Button("click") {
        coordinator.update(animated: true) {
          $0.toggle.toggle()
        }
      }
      .alignSelf(.center)
    }
    .padding(20)
    .asAnyNode
  }
}

final class NodeViewViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }

  func render() {
    view.render(node:
      List {
        ForEach(0..<100) {
          Header(text: "hello world")
        }
      }
      .width(.percent(100))
      .height(.percent(100))
      .asAnyNode
    )
  }

}

