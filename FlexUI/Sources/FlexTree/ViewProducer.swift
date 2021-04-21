//
//  ViewProducer.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/28.
//

public final class ViewProducer {
  
  public var viewTypeName: String
  public var reuseID: AnyHashable? = nil
  public var viewMaker: (() -> UIView)
  private var configurations: [(UIView) -> Void] = []
  private var deferConfigurations: [(UIView) -> Void] = []

  public init<T: UIView>(type: T.Type) {
    viewTypeName = String(describing: type)
    viewMaker = {
      let v = T()
      v.backgroundColor = .clear
      return v
    }
  }

  var configure: ((UIView) -> Void)? {
    guard configurations.isEmpty == false else {
      return nil
    }
    return { (v) in
      self.configurations.forEach { $0(v) }
    }
  }

  var deferConfigure: ((UIView) -> Void)? {
    guard deferConfigurations.isEmpty == false else {
      return nil
    }
    return { (v) in
      self.deferConfigurations.forEach { $0(v) }
    }
  }

  public func appendConfiguration(config: @escaping (UIView) -> Void) {
    configurations.append(config)
  }

  public func appendConfiguration<T: UIView>(as type: T.Type, config: @escaping (T) -> Void) {
    configurations.append({
      if let view = $0 as? T {
        config(view)
      }
    })
  }

  public func appendDeferConfiguration(config: @escaping (UIView) -> Void) {
    deferConfigurations.append(config)
  }

  public func appendDeferConfiguration<T: UIView>(as type: T.Type, config: @escaping (T) -> Void) {
    deferConfigurations.append({
      if let view = $0 as? T {
        config(view)
      }
    })
  }

}

public protocol ViewProducible {
  associatedtype ProductedView: UIView
}
