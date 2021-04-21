//
//  FlexNode+Debug.swift
//  FlexUI
//
//  Created by Li ChangMing on 2021/3/2.
//


extension FlexNode: CustomDebugStringConvertible {

  public var debugDescription: String {
    debugDesc(indent: 0)
  }

  private func debugDesc(indent: Int) -> String {
    let indentText = (0..<indent).reduce("") { (result, _) -> String in
      result + " |"
    }
    let content = "\(debugName) (\(layoutFrame) reuseID: \(viewProducer?.reuseID?.baseDesc ?? "nil") grow: \(style.flexGrow) shrink: \(style.flexShrink)\n"
    let childrenDesc = children.reduce("") { (result, node) -> String in
      result + node.debugDesc(indent: indent + 1)
    }
    return "\(indentText)\(content)\(childrenDesc)"
  }

  private var debugName: String {
    var name = "Div"
    if style.overflow == .scroll {
      name = "ScrollNode"
    } else if parent?.style.overflow == .some(.scroll) {
      name = "ScrollContent"
    } else  if children.count > 0 {
      switch style.flexDirection {
      case .row: name = "HStack"
      case .rowReverse: name = "HStackReverse"
      case .column: name = "VStack"
      case .columnReverse: name = "VStackReverse"
      @unknown default: break
      }
    } else if let view = viewProducer {
      switch view.viewTypeName {
      case "MPILabel": name = "Text"
      case "FLAnimatedImageView": name = "Image"
      default: name = view.viewTypeName
      }
    }

    name += " \(Unmanaged.passUnretained(self).toOpaque())"
    return name
  }

}
