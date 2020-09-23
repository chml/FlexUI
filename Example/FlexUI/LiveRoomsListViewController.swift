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
        .padding(12)
    }
    .asAnyNode
  }
}

struct LiveRoomCell: Component  {
  typealias Body = AnyNode
  let room: LiveRoom
  var id: AnyHashable { room.id }
  let widthPercent: CGFloat

  func isContentEqual(to other: LiveRoomCell) -> Bool {
    return self.room == other.room
  }

  var isHighlightable: Bool { true }
  var isHighlighted: Bool = false

  init(room: LiveRoom, widthPercent: CGFloat = 45) {
    self.room = room
    self.widthPercent = widthPercent
  }
  func body(with coordinator: SimpleCoordinator<LiveRoomCell>) -> AnyNode {
    View {
      VStack(alignItems: .stretch) {
        Image(room.imageURL)
          .aspectRatio(1)
          .width(.percent(100))
          .viewReuseID("image")
          .viewConfig({ (v) in
            v.clipsToBounds = true
            v.contentMode = .scaleAspectFill
          })
          .flexGrow(1)
          .overlay {
            Text(self.room.host)
              .textColor(.white)
              .viewReuseID("host")
              .bottom(10).start(10)
            Text("\(self.room.point)")
              .textColor(.white)
              .viewReuseID("point")
              .bottom(10).end(10)
          }
        Text(room.title)
          .numberOfLines(2)
          .viewReuseID("title")
          .flexShrink(1).flexGrow(1)
      }
    }
    .viewReuseID("wrapper")
    .viewConfig({ (v) in
      v.transform = isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
    })
    .width(.percent(widthPercent))
    .asAnyNode
  }

}

final class LiveRoomLayout: UICollectionViewFlowLayout {
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributes = super.layoutAttributesForElements(in: rect)?
      .map { $0.copy() } as? [UICollectionViewLayoutAttributes]

    attributes?
      .reduce([CGFloat: (CGFloat, [UICollectionViewLayoutAttributes])]()) {
        guard $1.representedElementCategory == .cell else { return $0 }
        return $0.merging([ceil($1.center.y): ($1.frame.origin.y, [$1])]) {
          ($0.0 < $1.0 ? $0.0 : $1.0, $0.1 + $1.1)
        }
      }
      .values.forEach { minY, line in
        line.forEach {
          $0.frame = $0.frame.offsetBy(dx: 0, dy: minY - $0.frame.origin.y)
        }
      }

    return attributes
  }
}


final class LiveRoomsListViewController: UIViewController, Component {
  typealias Body = AnyNode

  fileprivate var banners: [URL] = (0..<5).map { _ in randomImageURL() }
  fileprivate var rooms: [LiveRoom] = LiveRoom.generate(0, count: 21)
  let layout = LiveRoomLayout()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    let padding = floor(view.bounds.width*0.03)
    layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    flex.render()
  }

  func body(with coordinator: SimpleCoordinator<LiveRoomsListViewController>) -> AnyNode {
    List(collection: layout) {
      Section(id: "banners") {
        BannerNode(bannerImageURLs: self.banners) { (index) in
        }
      }
      Section(id: "rooms", header: LiveRoomHeader(id: "room Header", text: "Online")) {
        ForEach(self.rooms) {
          LiveRoomCell(room: $0)
        }
      }
    }
    .pullToRefresh({ (endRefreshing) in
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        coordinator.update { (vc) in
          vc.banners = (0..<5).map { _ in randomImageURL() }
          vc.rooms = vc.rooms.shuffled()
        }
        endRefreshing()
      }
    })
    .infiniteScroll({ (endRefreshing) in
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        coordinator.update { (vc) in
          vc.rooms.append(contentsOf: LiveRoom.generate(vc.rooms.count, count: 21))
        }
        endRefreshing(false)
      }
    })
    .onSelect({[weak self] (item) in
      if let cell = item.unwrap(as: LiveRoomCell.self) {
        self?.navigationController?.pushViewController(LiveRoomViewController(liveURL: cell.room.imageURL), animated: true)
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
