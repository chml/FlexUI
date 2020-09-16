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
    VStack(spacing: toggle ? 30: 8, alignItems: .stretch) {
      Image(URL(string:"https://s3.ifanr.com/wp-content/uploads/2020/09/anandtech.jpg!720")!).width(100).height(100)
        .viewReuseID(1)
        .viewConfig {
          $0.backgroundColor = .red
      }
      .alignSelf(!toggle ? .flexStart : .flexEnd)
      Image(URL(string:"https://s3.ifanr.com/wp-content/uploads/2020/09/3090.png!720")).width(100).height(100)
        .viewReuseID(2)
        .viewConfig {
          $0.backgroundColor = .green
      }
      .alignSelf(toggle ? .flexStart : .flexEnd)

      Text("سالانيو: أيقن يا سيدي أنني لو خاطرت بمالي مثل مخاطرتك لدرجت أهوائي تتعقب آمالي في تلك الآفاق البعيدة، أو لما وجدني من نشدني إلا عاكفًا على فريعات الأعشاب أستخبرها عن مهاب الرياح، أو مكبًّا على صور الأرض أبحث عن المرافئ والأرصفة والموانئ، فأيما شيء تبينت منه أدنى بأس على أوساقي مت له جزعًا.")
        .textColor(.green)
        .padding(20)

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
    view.flex.render(
      List {
        ForEach(0..<200) {
          Header(text: "hello world")
        }
      }
      .width(.percent(100))
      .height(.percent(100))
      .asAnyNode
    )
  }

}

