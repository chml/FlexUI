//
//  UserProfileViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

fileprivate struct AlubmNode: Component, Hashable {
  typealias Body = AnyNode
  let id: AnyHashable
  var photos: [URL]

  func body(with coordinator: Coordinator) -> AnyNode {
    VStack(alignItems: .stretch) {
      HStack {
        image(index: 0, coordinator).flexGrow(2)
        VStack(alignItems: .stretch) {
          image(index: 1, coordinator)
          image(index: 2, coordinator)
        }.flexGrow(1)
      }.flexGrow(1)
      HStack {
        image(index: 3, coordinator)
        image(index: 4, coordinator)
        image(index: 5, coordinator)
      }.flexGrow(1).flexShrink(1)
    }
    .asAnyNode
  }

  func image(index: Int, _ coordinator: Coordinator) -> AnyNode {
    let url = photos[index]
    return AnyNode(
      Image(url)
        .flexGrow(1)
        .aspectRatio(1)
        .viewReuseID(url)
        .viewConfig({ (v) in
          coordinator.config(imageView: v, index: index)
        })
    )
  }
  final class Coordinator: NSObject, ComponentCoordinator, UIGestureRecognizerDelegate {
    typealias Content = AlubmNode
    let context: Context

    weak var floatingImage: UIView? = nil

    init(with context: Context) {
      self.context = context
    }

    func config(imageView: UIView, index: Int) {
      imageView.tag = index
      imageView.clipsToBounds = true
      imageView.contentMode = .scaleAspectFill
      imageView.isUserInteractionEnabled = true
      if let gestures = imageView.gestureRecognizers {
        for g in gestures {
          imageView.removeGestureRecognizer(g)
        }
      }
      imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(imageLongPress(_:))))
    }

    @objc
    func imageLongPress(_ sender: UILongPressGestureRecognizer)  {
      let pos =  sender.location(in: sender.view?.superview)
      switch sender.state {
      case .began:
        if let view = sender.view {
          view.superview?.bringSubviewToFront(view)
          UIView.animate(withDuration: 0.15) {
            view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            view.alpha = 0.75
          }
          self.floatingImage = view
        }
      case .changed:
        self.floatingImage?.center = pos

      case .ended: fallthrough
      case .cancelled:
        if let view = self.floatingImage, let superview = view.superview {
          view.alpha = 1
          let oldIndex = view.tag
          var newIndex = oldIndex
          for v in superview.subviews {
            if v === view {
              continue
            } else if v.frame.contains(pos) {
              newIndex = v.tag
              break
            }
          }
          if oldIndex != newIndex {
            update(animated: true) { (n) in
              let photo = n.photos[oldIndex]
              n.photos.remove(at: oldIndex)
              n.photos.insert(photo, at: newIndex)
            }
          }
        }
        break
      default: break
      }
    }

  }
}

fileprivate struct TagsNode: Node, Hashable {
  let id: AnyHashable
  let title: String
  let tags: [String]
  let color: UIColor
  var body: AnyNode {
    HStack(spacing: 8, alignItems: .baseline, wrap: .wrap, lineSpacing: 8) {
      Text("\(title) ")
        .font(.preferredFont(forTextStyle: .callout))
        .baselineFunc { (_, width, height) -> CGFloat in
          return height + 6 // bottom padding of the tags
      }
      .viewReuseID("title")
      ForEach(tags) {
        Text($0)
          .font(.preferredFont(forTextStyle: .callout))
          .padding(of: .horizontal, 12)
          .padding(of: .vertical, 6)
          .viewConfig { (v) in
            v.backgroundColor = self.color
            v.layer.cornerRadius = min(v.bounds.height/2, 16)
            v.layer.masksToBounds = true
        }
      }
    }
    .flexGrow(1).flexShrink(1)
    .padding(12)
    .asAnyNode
  }
}

final class UserProfileViewController: UIViewController, Component {

  var album: [URL] = [
    URL(string:"https://s3.ifanr.com/wp-content/uploads/2020/09/3090.png!720")!,
    URL(string:"https://s3.ifanr.com/wp-content/uploads/2020/09/anandtech.jpg!720")!,
    URL(string:"https://s3.ifanr.com/wp-content/uploads/2020/09/showup2.gif!720")!,
    URL(string:"https://s3.ifanr.com/wp-content/uploads/2020/09/nvidiafuture.jpg!720")!,
    URL(string:"https://s3.ifanr.com/wp-content/uploads/2020/09/nvidiabroadcast.png!720")!,
    URL(string:"https://s3.ifanr.com/wp-content/uploads/2020/09/1080ti.jpg!720")!,
  ]
  var tags1: [String] = ["刚买来新电脑的你", "是不是", "马上就迫不及", "待地装上了各种软件，如", "微信、Office、浏览器等，却忽略了许多电脑的自带软件。" ]
  var tags2: [String] = [ "是不是", "马上就", "迫不及", "待地"]

  typealias Body = AnyNode
  func body(with coordinator: SimpleCoordinator<UserProfileViewController>) -> AnyNode {
    List {
      AlubmNode(id: 0, photos: self.album)
      TagsNode(id: 1, title: "爱好1", tags: self.tags1, color: .orange)
      TagsNode(id: 2, title: "爱好2", tags: self.tags2, color: .green)
    }
    .onSelect({ (node) in
      if let tagsNode = node.unwrap(as: TagsNode.self) {
        let vc = UserProfileTagsEditingViewController(title: tagsNode.title, tags: tagsNode.tags)
        vc.onSave = { (tags) in
          coordinator.update {
            if node.id == AnyHashable(1) {
              $0.tags1 = tags
            } else {
              $0.tags2 = tags
            }
          }
        }
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
      }
    })
      .width(.percent(100))
      .height(.percent(100))
      .asAnyNode
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    flex.render()
  }

}
