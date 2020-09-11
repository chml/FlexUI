//
//  ViewController.swift
//  FlexUI
//
//  Created by chmlaiii@gmail.com on 08/26/2020.
//  Copyright (c) 2020 chmlaiii@gmail.com. All rights reserved.
//

import UIKit
import FlexUI


private struct Cell: Node {
  let title: String
  let viewController: () -> UIViewController

  init<VC: UIViewController>(_ title: String, _ vc: VC.Type) {
    self.title = title
    self.viewController = { VC() }
  }

  var body: AnyNode {
    HStack(spacing: 20, alignItems: .center) {
      Text(title).flexShrink(1).flexGrow(1)
//      Image(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysOriginal))
    }
    .padding(20)
    .asAnyNode
  }
}

final class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "FlexUI"
    flex.render {
      List {
        Section(id: 0, header: Text("Basic")) {
          Cell("Flexbox Layout", FlexboxViewController.self)
          Cell("Diffable TableView", DiffTableViewController.self)
          Cell("Diffable CollectionView", DiffCollectionViewController.self)
          Cell("Custom CollectionViewLayout", DiffTableViewController.self)
          Cell("NodeView && AutoLayout", NodeViewViewController.self)
        }
        Section(id: 1, header: Text("Demo")) {
          Cell("Counter", CounterDemoViewController.self)
          Cell("User Profile ", UserProfileViewController.self)
          Cell("Timeline", UIViewController.self)
        }
      }
      .onSelect {[weak self] (item) in
        if let cell = item.unwrap(as: Cell.self) {
          self?.navigationController?.pushViewController(cell.viewController(), animated: true)
        }
      }
      .width(.percent(100))
      .height(.percent(100))
    }
  }

}
