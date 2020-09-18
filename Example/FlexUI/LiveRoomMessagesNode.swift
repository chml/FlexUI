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

struct LiveRoomMessageCell: Node, Hashable {
  let message: LiveRoomMessage

  var id: AnyHashable { message.id }

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

#if DEBUG
extension LiveRoomMessage {
  static func generateMessages() -> [LiveRoomMessage] {
    return Array(0..<10).map { n in
      LiveRoomMessage(id: n, user: "User\(n)", message: "long long message \(n)")
    }
  }
}
#endif
//
//#if canImport(SwiftUI)
//import SwiftUI
//@available(iOS 13.0, *)
//struct _LiveRoomMessageCell_Preview: PreviewProvider {
//  typealias Previews = LiveView<NodeView>
//
//  static var previews: LiveView<NodeView> {
//    return LiveView(NodeView(LiveRoomMessageCell(message: LiveRoomMessage.generateMessages().first!).asAnyNode))
//  }
//
//}
//#endif
