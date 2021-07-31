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
  let avatarURL: URL
  let message: String
}

struct LiveRoomMessageCell: Node, Hashable {
  let isCompact: Bool
  let message: LiveRoomMessage

  var id: AnyHashable { message.id }

  var body: AnyNode {
    HStack(spacing: 12, justifyContent: isCompact ? .flexEnd : .flexStart, alignItems: .flexStart) {
      ForEach([
          Image(.url(message.avatarURL))
            .viewReuseID("avatar")
            .viewConfig { (v) in
              v.layer.cornerRadius = v.bounds.width/2
              v.layer.masksToBounds = true
            }
            .width(30).height(30)
            .asAnyNode,

          VStack(spacing: 12) {
            Text(message.user)
              .font(.preferredFont(forTextStyle: .caption1))
              .textColor(.blue)
              .alignSelf(isCompact ? .flexEnd : .flexStart)
              .flexGrow(1)
              .viewReuseID("userName")
            Text(message.message)
              .font(.preferredFont(forTextStyle: .caption1))
              .textColor(.white)
              .flexGrow(1)
              .viewReuseID("text")
          }
          .padding(8)
          .background {
            View()
              .viewReuseID("bubble")
              .viewConfig { (v) in
                v.backgroundColor = .init(white: 0.2, alpha: 0.3)
                v.layer.cornerRadius = min(v.bounds.width/2, 8)
                v.layer.masksToBounds = true
              }
              .width(.percent(100)).height(.percent(100))
          }
          .flexShrink(1)
          .asAnyNode
      ].reversed(if: isCompact))
    }
    .padding(12)
    .flexGrow(1)
    .flexShrink(1)
    .asAnyNode
  }
}


struct LiveRoomMessagesNode: CoordinateNode {
  typealias Body = AnyNode

  let compact: Bool
  var messages: [LiveRoomMessage]


  func body(with coordinator: DefaultCoordinator<LiveRoomMessagesNode>) -> AnyNode {
    VStack(alignItems: .stretch) {
      List(data: messages) { msg in
        LiveRoomMessageCell(isCompact: compact, message: msg)
      }
      .reversed(true)
      .viewReuseID("msglist")
      .viewConfig({ (v) in
        v.separatorStyle = .none
        v.backgroundColor = .clear
      })
      .flexGrow(1)
    }
    .flexGrow(1)
    .asAnyNode
  }

}

//#if DEBUG
extension LiveRoomMessage {
  static func generateMessages(_ seed: Int = 0 , _ count: Int = 20) -> [LiveRoomMessage] {

    let messages: [String] = [
      "引号，是标点符号的一种，标示引用、着重、特别用意的符号。 中国国家标准《标点符号用法》将“引号”定义为标识语段中直接引用的内容或需要特别指出的成分。“行文中直接引用的话，用引号标示。”“需要着重论述的对象，用引号标示。”“具有特殊含义的词语，也用引号标示",
      "《奇异人生 2》永久免费，《荒野大镖客 2》马上结束促销，还有更多 iOS 应用游戏促销中",
      "6666666",
      "666",
    ]

    return Array(seed..<count).map { n in
      LiveRoomMessage(id: n, user: "User\(n)", avatarURL: randomImageURL(), message: "\(n) \(messages.randomElement()!)")
    }
  }
}
//#endif
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
