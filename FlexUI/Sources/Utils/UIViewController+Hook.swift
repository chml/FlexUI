//
//  UIViewController+Hook.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/25.
//

import class UIKit.UIViewController

import Nuke
import NukeWebPPlugin

extension UIViewController {

  @objc static func _flexSwiftLoad() {
    ImageLoadingOptions.shared.isPrepareForReuseEnabled = false
    ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
    WebPImageDecoder.enable()
  }

}
