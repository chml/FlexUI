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

  let liveURL: URL

  init(liveURL: URL) {
    self.liveURL = liveURL
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  enum DisplayMode {
    case portraintNormal
    case portraintFullScreen
    case landscapeFullScreen
  }
  var displayMode: DisplayMode = .portraintNormal
  var messages: [LiveRoomMessage] = LiveRoomMessage.generateMessages(0, 30)

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    flex.render()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  func liveStreamNode() -> AnyNode {
    Image(liveURL)
      .viewReuseID("hostLiveStream")
      .viewConfig({ (v) in
        v.contentMode = .scaleAspectFill
      })
      .asAnyNode
  }

  func closeButton() -> AnyNode {
    Button(" ㄨ ") { [weak self] in
      self?.navigationController?.popViewController(animated: true)
    }
    .viewReuseID("closeBtn")
    .viewConfig({ (v) in
      v.backgroundColor = .red
    })
    .asAnyNode
  }

  func fullScreenButton(_ coordinator: Coordinator) -> AnyNode {
    let isFullScreen = coordinator.content.displayMode != .portraintNormal
    let title = isFullScreen ? "◢◤" : "◤◢"
    return Button(title) {
      coordinator.update(animated: true) { (vc) in
        if vc.displayMode == .portraintNormal {
          vc.displayMode = .portraintFullScreen
        } else if vc.displayMode == .portraintFullScreen {
          vc.displayMode = .portraintNormal
        }
      }
    }
    .viewReuseID("fullScreenBtn")
    .viewConfig({ (v) in
      v.backgroundColor = .red
    })
    .asAnyNode
  }

  func safeInsets() -> UIEdgeInsets {
    var insets = view.layoutMargins
    insets.left = 0
    insets.right = 0
    return insets
  }

  func body(with coordinator: SimpleCoordinator<LiveRoomViewController>) -> AnyNode {
    let insets = safeInsets()
    if insets == .zero { return EmptyNode().asAnyNode }
    switch displayMode {


    case .portraintNormal:
      return VStack(justifyContent:.spaceAround, alignItems: .stretch) {
        liveStreamNode()
          .aspectRatio(16.0/9.0)
        LiveRoomMessagesNode(compact: false, messages: self.messages)
          .flexGrow(1)
      }
      .flexGrow(1)
      .overlay({
        self.closeButton()
          .top(insets.top + 20)
          .start(20)
        self.fullScreenButton(coordinator)
          .top(insets.top + 20)
          .end(20)
      })
      .height(.percent(100))
      .padding(insets)
      .asAnyNode
      
    case .portraintFullScreen:
      return VStack(justifyContent:.spaceAround, alignItems: .stretch) {
        liveStreamNode()
          .flexGrow(1)
      }
      .flexGrow(1)
      .overlay({
        LiveRoomMessagesNode(compact: true, messages: self.messages)
          .width(.percent(70))
          .height(.percent(50))
          .end(0)
          .bottom(insets.bottom)
        self.closeButton()
          .top(insets.top + 20)
          .start(20)
        self.fullScreenButton(coordinator)
          .top(insets.top + 20)
          .end(20)
      })
      .height(.percent(100))
      .padding(insets)
      .asAnyNode
    case .landscapeFullScreen:
      return VStack(alignItems: .stretch) {
        Image(randomImageURL())
          .viewReuseID("hostLiveStream")
          .aspectRatio(16.0/9.0)
        LiveRoomMessagesNode(compact: true, messages: LiveRoomMessage.generateMessages())
          .flexGrow(1).flexShrink(1)
      }
      .width(.percent(100))
      .height(.percent(100))
      .asAnyNode
    }
  }

}
