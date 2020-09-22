//
//  NodeViewViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/8.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI
import SnapKit

final class NodeViewViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    let nodeView = NodeView(HStack{
      Text("node view")
    }.asAnyNode)

    nodeView.backgroundColor = .gray

    view.addSubview(nodeView)
    nodeView.snp.makeConstraints { (make) in
      make.center.equalTo(view)
    }
  }

}

