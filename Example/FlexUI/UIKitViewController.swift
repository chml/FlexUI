//
//  UIKitViewController.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/12/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI
import SnapKit


//final class Cell: UITableViewCell, Component {
//  typealias Body = AnyNode
//
//  var node: FlexNode?
//
//  override var intrinsicContentSize: CGSize {
//    return .zero
//  }
//
//  func body(with coordinator: SimpleCoordinator<Cell>) -> AnyNode {
//    EmptyNode().asAnyNode
//  }
//
//}

final class UIKitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView(frame: view.bounds, style: .plain)
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }

    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100

  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell(style: .default, reuseIdentifier: "")
  }
}
