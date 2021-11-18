//
//  PlaygroundViewController.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2021/9/1.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI


//final class SurroundLayout: UICollectionViewFlowLayout {
//  override init() {
//    super.init()
//    itemSize = .init(width: 200, height: 200)
//    minimumLineSpacing = 10
//    minimumInteritemSpacing = 10
//    scrollDirection = .horizontal
//  }
//
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//    true
//  }
//
//  override func prepare() {
//    if let bounds = collectionView?.bounds {
//      let inset = (bounds.height - itemSize.height)/2
//      sectionInset = .init(top: inset, left: 0, bottom: 0, right: 0)
//    }
//    super.prepare()
//  }
//
//  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//    let results = super.layoutAttributesForElements(in: rect)
//    guard let colview = collectionView else {
//      return results
//    }
//    let bounds = colview.bounds
//    return results
//  }
//}

struct TextCell: Node, Hashable {
  let str: String

  var body: AnyNode {
    View(of: UIView.self) {
      VStack(justifyContent: .center, alignItems: .center) {
        Text(str)
          .font(.boldSystemFont(ofSize: 20))
          .textColor(.white)
          .textAlignment(.center)
          .viewConfig { v in
            v.backgroundColor = .green
          }
      }
    }
    .viewConfig({ v in
      v.backgroundColor = .blue
    })
    .width(200)
    .height(200)
    .asAnyNode
  }
}


final class PlaygroundViewController: UIViewController {

  lazy var colLayout = SurroundLayout()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    flex.render {
      VStack(justifyContent:.center, alignItems:.stretch) {
        List(collection: self.colLayout, data: (0..<100)) { i in
          TextCell(str: "\(i)")
        }
        .viewConfig({ v in
          v.backgroundColor = .red
        })
        .width(.percent(100))
        .height(250)
      }
      .flexShrink(1)
      .width(.percent(100))
      .height(.percent(100))
    }
  }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct PlaygroundViewController_Preview: PreviewProvider {
  static var previews: some View {
    return UIViewControllerPreview(PlaygroundViewController())
  }
}
#endif
