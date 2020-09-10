//
//  FlexNode.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/27.
//

import yoga

public final class YogaNodeLayout {
  public let container: FlexNode
  public let root: FlexNode

  var contentSize: CGSize {
    return root.layoutFrame.size
  }

  public init(root: FlexNode, container: FlexNode) {
    self.root = root
    self.container = container
  }

}


public final class FlexNode {

  private let yogaRef: YGNodeRef = YGNodeNew()

  public lazy var style = { FlexStyle(nodeRef: yogaRef) }()
  public private(set) lazy var children: [FlexNode] = []
  public private(set) weak var parent: FlexNode? = nil


  public var nodeType: NodeType {
    get { YGNodeGetNodeType(yogaRef) }
    set { YGNodeSetNodeType(yogaRef, newValue) }
  }

  public typealias MeasureFunc = (_ node: FlexNode, _ width:CGFloat, _ widthMode: MeasureMode, _ height: CGFloat, _ heightMode: MeasureMode) -> CGSize
  public var measureFunc: MeasureFunc? {
    didSet {
      if measureFunc != nil {
        YGNodeSetMeasureFunc(yogaRef,  NodeMeasureFunc(ref:width:widthMode:height:heightMode:))
      } else {
        YGNodeSetMeasureFunc(yogaRef, nil)
      }
    }
  }

  public typealias BaselineFunc = (_ node: FlexNode, _ width: CGFloat, _ height: CGFloat) -> CGFloat
  public var baselineFunc: BaselineFunc? {
    didSet {
      if baselineFunc != nil {
        YGNodeSetBaselineFunc(yogaRef, NodeBaselineFunc(ref:width:height:))
      } else {
        YGNodeSetBaselineFunc(yogaRef, nil)
      }
    }
  }

  public var asRootNode: Bool = false // for View Recycler
  public var viewProducer: ViewProducer?
  public var coordinator: AnyComponentCoordinator? = nil

  public var isLeaf: Bool {
    return children.count == 0
  }

  deinit {
    YGNodeFree(yogaRef)
  }

  public init() {
    YGNodeSetContext(yogaRef, Unmanaged.passUnretained(self).toOpaque())
  }

  public func indexOfChild(_ child: FlexNode) -> Int? {
    return children.firstIndex { (n) -> Bool in
      return child === n
    }
  }

  public func insertChild(_ child: FlexNode, at index: Int? = nil) {
    let i = index ?? children.count
    child.parent = self
    children.insert(child, at: i)
    YGNodeInsertChild(yogaRef, child.yogaRef, UInt32(i))
  }

  public func removeAllChildren() {
    children = []
    YGNodeRemoveAllChildren(yogaRef)
  }

  public func removeChild(_ child: FlexNode) {
    YGNodeRemoveChild(yogaRef, child.yogaRef)
    if let index = children.firstIndex(where: { (n) -> Bool in
      return n === child
    }) {
      children.remove(at: index)
    }
    child.parent = nil
  }

  public var isDirty: Bool {
    get { YGNodeIsDirty(yogaRef) }
    set { YGNodeMarkDirty(yogaRef) }
  }

  public var hasNewLayout: Bool {
    YGNodeGetHasNewLayout(yogaRef)
  }

  public func calculateLayout(width: CGFloat, height: CGFloat, direction: Direction) -> YogaNodeLayout {
    var dir = direction
    if dir == .inherit {
      dir = UIApplication.shared.delegate?.window??.direction ?? .LTR
    }
    let container = FlexNode()
    container.insertChild(self)
    YGNodeCalculateLayout(container.yogaRef, Float(width), Float(height), dir)
    return YogaNodeLayout(root: self, container: container)
  }

  public var layoutFrame: CGRect {
    return CGRect(
      x: CGFloat(YGNodeLayoutGetLeft(yogaRef)),
      y: CGFloat(YGNodeLayoutGetTop(yogaRef)),
      width: CGFloat(YGNodeLayoutGetWidth(yogaRef)),
      height:CGFloat(YGNodeLayoutGetHeight(yogaRef)))
  }

  public var convertedLayoutFrame: CGRect {
    var frame = layoutFrame
    if parent?.viewProducer == nil {
      if let parentLayoutFrame = parent?.convertedLayoutFrame {
        frame.origin.x += parentLayoutFrame.origin.x
        frame.origin.y += parentLayoutFrame.origin.y
      }
    }
    return frame
  }


}

private func NodeMeasureFunc(ref: YGNodeRef!, width: Float, widthMode: MeasureMode, height: Float, heightMode: MeasureMode) -> YGSize {
  let node = Unmanaged<FlexNode>.fromOpaque(YGNodeGetContext(ref)).takeUnretainedValue()
  if let fn = node.measureFunc {
    let size = fn(node, CGFloat(width), widthMode, CGFloat(height), heightMode)
    return YGSize(width: Float(ceil(size.width)), height: Float(ceil(size.height)))
  }
  return YGSize(width: width, height: height)
}

private func NodeBaselineFunc(ref: YGNodeRef!, width: Float, height: Float) -> Float {
  let node = Unmanaged<FlexNode>.fromOpaque(YGNodeGetContext(ref)).takeUnretainedValue()
  if let fn = node.baselineFunc {
    return Float(fn(node, CGFloat(width), CGFloat(height)))
  }
  return height
}


extension FlexNode: CustomDebugStringConvertible {

  public var debugDescription: String {
    debugDesc(indent: 0)
  }

  private func debugDesc(indent: Int) -> String {
    let indentText = (0..<indent).reduce("") { (result, _) -> String in
      result + " |"
    }
    let content = "\(debugName) (\(layoutFrame)\n"
    let childrenDesc = children.reduce("") { (result, node) -> String in
      result + node.debugDesc(indent: indent + 1)
    }
    return "\(indentText)\(content)\(childrenDesc)"
  }

  private var debugName: String {
    if style.overflow == .scroll {
      return "ScrollNode"
    }
    if parent?.style.overflow == .some(.scroll) {
      return "ScrollContent"
    }
    if children.count > 0 {
      switch style.flexDirection {
      case .row: return "HStack"
      case .rowReverse: return "HStackReverse"
      case .column: return "VStack"
      case .columnReverse: return "VStackReverse"
      @unknown default: break
      }
    }
    if let view = viewProducer {
      switch view.viewTypeName {
      case "MPILabel": return "Text"
      case "FLAnimatedImageView": return "Image"
      default: return view.viewTypeName
      }
    }

    return "Div"
  }

}
