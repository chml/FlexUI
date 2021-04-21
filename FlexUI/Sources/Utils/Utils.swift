//
//  Utils.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/27.
//

struct UniqueIdentifier: Hashable { }

extension CGFloat {

  @inlinable
  var float: Float {
    return Float(self)
  }

}

extension Float {

  @inlinable
  var cgFloat: CGFloat {
    return CGFloat(self)
  }

}


extension CGSize {

  @inlinable
  var normalized: CGSize {
    var normal = self
    if normal.width.isNaN {
      normal.width = 1e10
    }
    if normal.height.isNaN {
      normal.height = 1e10
    }
    return normal
  }

}


extension AnyHashable {
  var baseDesc: String {
    if let base = base as? CustomStringConvertible {
      return "\(base)"
    }
    return "\(self)"
  }
}
