//
//  ViewController.swift
//  FlexUI
//
//  Created by chmlaiii@gmail.com on 08/26/2020.
//  Copyright (c) 2020 chmlaiii@gmail.com. All rights reserved.
//

import UIKit
import FlexUI

extension UIColor {
  static var random: UIColor {
    UIColor(red: CGFloat(arc4random()%255)/255.0, green: CGFloat(arc4random()%255)/255.0, blue: CGFloat(arc4random()%255)/255.0, alpha: 0.9)
  }
}


struct TextCell: Node, Hashable {
  let title: String
  var body: AnyNode {
    Flex {
      Text(title)
        .paddding(20)
        .viewReuseID("label")
    }
  }
}

struct ImageTextCell: Node, Hashable {
  let title: String
  var body: AnyNode {
    Flex {
      HStack(spacing: 20) {
        Image(URL(string: "https://media.ifanrusercontent.com/user_files/wpdata/images/b4/33/b43360ece71de9dfcee48bf4fef38bfa31ba194b-bcb40bac29bab334e61726cf476645977fb748c6.jpg"))
          .width(80)
          .height(80)
          .viewConfig { (v) in
            v.layer.cornerRadius = 20
            v.layer.masksToBounds = true
          }
          .viewReuseID("image")
        Text(title)
          .viewReuseID("label")
      }
      .paddding(20)
    }
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let node = Flex {
      List(of: UITableView.self) {
        TextCell(title: "hahahah")
        ImageTextCell(title: "hahahah")
        TextCell(title: "hahahah")
        ImageTextCell(title: "hahahah")
        TextCell(title: "hahahah")

        Text("noway")
          .paddding(20)
      }
      .onSelect({ (node) in
        if let n = node.unwrap(as: TextCell.self) {
          print("Selected: \(n.title)")
        }
      })
      .pullToRefresh({ (endRefreshing) in
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
          endRefreshing()
        }
      })
      .infiniteScroll({ (endRefreshing) in
      })
      .width(.percent(100))
      .height(.percent(100))
    }
    node.buildYogaTree().calculateLayout(width: view.bounds.width, height: view.bounds.height).makeViews(in: view)
  }

}

//#if canImport(SwiftUI)
//import SwiftUI
//@available(iOS 13.0, *)
//struct _ViewController_Preview: PreviewProvider {
//  typealias Previews = LiveView<UIViewController>
//
//  static var previews: LiveView<UIViewController> {
//    return LiveView(ViewController())
//  }
//
//}
//#endif


