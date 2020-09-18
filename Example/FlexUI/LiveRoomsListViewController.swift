//
//  LiveRoomsListViewController.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/17.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI


struct LiveRoom: Hashable {
  let id: Int
  let imageURL: URL
  let title: String
  let host: String
  let point: Int
}

extension LiveRoom {
  static func generate(_ seed: Int, count: Int = 20) -> [LiveRoom] {
    (seed..<seed + count).map { i in
      LiveRoom(id: i, imageURL: randomImageURL(), title: "Room\(i%2==0 ? "": "0000000000000000000000000") Title \(i)", host: "Host\(i)", point: i * 12)
    }
  }
}

struct LiveRoomHeader: Node, Hashable {
  let id: AnyHashable
  let text: String
  var body: AnyNode {
    HStack {
      Text(text).flexGrow(1).flexShrink(1)
        .padding(of: .vertical, 12)
    }
    .asAnyNode
  }
}

struct LiveRoomCell: Node, Hashable {
  let room: LiveRoom
  var id: AnyHashable { room.id }
  let widthPercent: CGFloat
  init(room: LiveRoom, widthPercent: CGFloat = 45) {
    self.room = room
    self.widthPercent = widthPercent
  }
  var body: AnyNode {
    VStack(alignItems: .stretch) {
      Image(room.imageURL)
        .aspectRatio(1)
        .width(.percent(100))
        .viewConfig({ (v) in
          v.clipsToBounds = true
          v.contentMode = .scaleAspectFill
        })
        .flexGrow(1)
        .overlay {
          Text(self.room.host).textColor(.white).bottom(10).start(10)
          Text("\(self.room.point)").textColor(.white).bottom(10).end(10)
        }
      Text(room.title)
        .numberOfLines(2)
        .flexShrink(1).flexGrow(1)
    }
    .width(.percent(widthPercent))
    .asAnyNode
  }

}

final class LiveRoomsListViewController: UIViewController, Component {
  typealias Body = AnyNode

  fileprivate var online: [LiveRoom] = LiveRoom.generate(0, count: 21)
  fileprivate var offline: [LiveRoom] = LiveRoom.generate(100, count: 20)
  let layout = UICollectionViewFlowLayout()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    let padding = floor(view.bounds.width*0.03)
    layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    flex.render()
  }

  func body(with coordinator: SimpleCoordinator<LiveRoomsListViewController>) -> AnyNode {
    List(collection: layout, data: [("Online", online), ("Offline", offline)]) { data in
      Section(id: data.0, header: LiveRoomHeader(id: data.0, text: data.0)) {
        ForEach(data.1) {
          LiveRoomCell(room: $0)
        }
      }
    }
    .onSelect({[weak self] (item) in
      if let cell = item.unwrap(as: LiveRoomCell.self) {
        print("\(cell.room)")
        self?.navigationController?.pushViewController(LiveRoomViewController(), animated: true)
      }
    })
    .viewConfig({ (v) in
      v.backgroundColor = .white
    })
    .width(.percent(100))
    .height(.percent(100))
    .asAnyNode
  }

}
