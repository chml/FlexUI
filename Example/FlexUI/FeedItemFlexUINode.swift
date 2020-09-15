//
//  FeedItemFlexUINode.swift
//  LayoutFrameworkBenchmark
//
//  Created by Li ChangMing on 2020/9/15.
//

import UIKit
import FlexUI


struct FLFeedItemNode: Node {
  let data: FeedItemData
  var body: AnyNode {
    VStack(alignItems: .stretch) {
      FLTopBarNode(text: data.actionText)
      FLMiniProfileNode(name: data.posterName, headline: data.posterHeadline, time: data.posterTimestamp, comment: data.posterComment)
      FLMiniContentNode(title: data.contentTitle, domain: data.contentDomain)
      FLSocialActionsNode()
      FLCommentNode(comment: data.actorComment)
    }
    .asAnyNode
  }
}

private struct FLTopBarNode: Node {
  let text: String
  var body: AnyNode {
    HStack(justifyContent: .spaceBetween) {
      Text(text).flexGrow(1).flexShrink(1)
      Text("...")
    }
    .asAnyNode
  }
}

private struct FLMiniProfileNode: Node {
  let name: String
  let headline: String
  let time: String
  let comment: String

  var body: AnyNode {
    VStack {
      HStack(spacing: 4) {
        Image(UIImage(named: "50x50.png"))
        VStack {
          Text(name)
            .viewConfig { (v) in
              v.backgroundColor = .yellow
          }
          Text(headline)
            .numberOfLines(3)
            .viewConfig { (v) in
              v.backgroundColor = .yellow
          }
          Text(time)
            .viewConfig { (v) in
              v.backgroundColor = .yellow
          }
        }.flexGrow(1).flexShrink(1)
      }
      Text(comment)
    }
    .padding(of: .left, CGFloat(4))
    .asAnyNode
  }
}

private struct FLMiniContentNode: Node {
  let title: String
  let domain: String

  var body: AnyNode {
    VStack(alignItems: .stretch) {
      Image(UIImage(named: "350x200.png"))
        .viewConfig { v in
          v.backgroundColor = .orange
          v.contentMode = .scaleAspectFit
      }
      Text(title).flexGrow(1).flexShrink(1)
      Text(domain).flexGrow(1).flexShrink(1)
    }
    .asAnyNode
  }

}


private struct FLSocialActionsNode: Node {
  var body: AnyNode {
    HStack(justifyContent: .spaceBetween) {
      Text("Like")
        .viewConfig { (v) in
          v.backgroundColor = .green
      }
      Text("Comment")
        .viewConfig { (v) in
          v.backgroundColor = .green
      }
      Text("Share")
        .viewConfig { (v) in
          v.backgroundColor = .green
      }
    }
    .asAnyNode
  }
}

private struct FLCommentNode: Node {
  let comment: String

  var body: AnyNode {
    HStack(spacing: 4) {
      Image(UIImage(named: "50x50.png"))
      Text(comment)
        .flexGrow(1).flexShrink(1)
        .viewConfig { (v) in
          v.contentMode = .scaleAspectFit
          v.backgroundColor = .orange
      }
    }
    .asAnyNode
  }
}
