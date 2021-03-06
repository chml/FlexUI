//
//  NodeViewViewController.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/8.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI
import SnapKit

final class NodeViewViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    let nodeView = NodeView(constraint: .fitWidth(view.bounds.width),
      VStack(spacing: 20) {
        Text("node view")
        Text("node view2")
          .textColor(.red)
      }
      .padding(of: .top, 100)
      .asAnyNode
    )

    nodeView.backgroundColor = .gray

    view.addSubview(nodeView)
    nodeView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }

}

