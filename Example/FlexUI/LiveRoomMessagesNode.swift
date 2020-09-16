//
//  LiveRoomMessagesNode.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/16.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

struct LiveRoomMessage: Hashable {
  let id: Int
  let user: String
  let message: String
}

struct LiveRoomMessageCell: Node {
  let message: LiveRoomMessage

  var id: AnyHashable { message.id }
  func isContentEqual(to other: LiveRoomMessageCell) -> Bool {
    return message == other.message
  }

  var body: AnyNode {
    HStack(spacing: 8, wrap: .wrap, lineSpacing: 8) {
      Text("\(message.user): ")
        .flexGrow(1).flexShrink(1)
      Text("\(message.message)")
        .flexGrow(1).flexShrink(1)
    }
    .asAnyNode
  }
}

struct LiveRoomMessagesNode: Component {
  typealias Body = AnyNode

  var messages: [LiveRoomMessage]

  func body(with coordinator: SimpleCoordinator<LiveRoomMessagesNode>) -> AnyNode {
    List(data: messages) { msg in
      LiveRoomMessageCell(message: msg)
    }
    .reversed(true)
    .asAnyNode
  }

}
