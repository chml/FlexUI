//
//  LiveRoomViewController.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/16.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

final class LiveRoomViewController: UIViewController, Component {

  typealias Body = AnyNode

  func body(with coordinator: SimpleCoordinator<LiveRoomViewController>) -> AnyNode {
    EmptyNode().asAnyNode
  }

}
