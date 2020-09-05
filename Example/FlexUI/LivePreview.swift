//
//  LivePreview.swift
//  YogaUI
//
//  Created by 黎昌明 on 2020/8/17.
//


#if canImport(SwiftUI)// && DEBUG
import SwiftUI
import FlexUI

@_exported import protocol SwiftUI.PreviewProvider

public protocol LiveViewContent {
  func makeView() -> UIView
}

//extension Node: LiveViewContent where Node {
//  public func makeView() -> UIView {
//    let view = NodeView()
//    view.node = AnyNode(self)
//    return view
//  }
//}

extension UIView: LiveViewContent {
  public func makeView() -> UIView {
    return self
  }
}

extension UIViewController: LiveViewContent {
  public func makeView() -> UIView {
    return self.view
  }
}



@available(iOS 13.0, *)
public struct LiveView<Content: LiveViewContent>: UIViewRepresentable {

  let children: Content

  public init (_ children: Content) {
    self.children = children
  }

  public func makeUIView(context: Context) -> UIView {
    children.makeView()
  }

  public func updateUIView(_ view: UIView, context: Context) {
  }

}

#endif
