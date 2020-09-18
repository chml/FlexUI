//
//  DiffCollectionViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI
private struct Header: Node {
  let id: AnyHashable
  func isContentEqual(to other: Header) -> Bool {
    return text == other.text
  }
  let text: String
  var body: AnyNode {
    Text(text)
      .textColor(.random)
      .padding(20)
      .asAnyNode
  }

}

private struct Cell: Node {
  let id: AnyHashable
  func isContentEqual(to other: Cell) -> Bool {
    return text == other.text
  }
  let text: String
  var body: AnyNode {
    Text(text)
      .textColor(.random)
      .width(.percent(45))
      .viewConfig({ (v) in
        v.backgroundColor = .gray
      })
      .asAnyNode
  }

}

final class DiffCollectionViewController: UIViewController, Component {

  typealias Body = AnyNode

  var state: [Int] = Array(0..<10)

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    flex.render()
  }

  func body(with coordinator: SimpleCoordinator<DiffCollectionViewController>) -> AnyNode {
    return List(collection: UICollectionViewFlowLayout(), data: state) { (i) in
      Section(id: i, header: Header(id: i, text: "header \(i)")) {
        ForEach(0..<i) {
          Cell(id: "\(i)-\($0)", text: "section\(i) item\($0)")
        }
      }
    }
    .pullToRefresh({ (endRefreshing) in
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        coordinator.update {
          $0.state.shuffle()
        }
      }
      endRefreshing()
    })
      .viewConfig({ (v) in
        v.backgroundColor = .white
      })
      .width(.percent(100))
      .height(.percent(100))
      .asAnyNode
  }

}
