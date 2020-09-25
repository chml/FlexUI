//
//  LiveRoomToolBarNode.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/23.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI


struct LiveRoomToolBarNode: Component {
  typealias Body = AnyNode

  let iconURLs: [URL]

  func body(with coordinator: SimpleCoordinator<LiveRoomToolBarNode>) -> AnyNode {
    HStack {
    }
    .asAnyNode
  }
}
