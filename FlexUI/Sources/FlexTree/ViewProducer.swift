//
//  ViewProducer.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/28.
//

public protocol ViewProducerType {
  var viewTypeName: String { get set }
  var reuseID: AnyHashable? { get set }
  var viewMaker: () -> UIView { get set }

  // view 初始化、复用时调用；注意此时 view 未完成布局
  var viewConfig: ((UIView) -> ())? { get }
  func appendViewConfig(_ config: @escaping (UIView)->())

  // view tree 完成布局后调用
  var viewDidLoad: ((UIView) -> ())? { get }
  func appendViewDidLoad(_ config: @escaping (UIView)->())
}

extension ViewProducerType {
  public func appendViewConfig<T: UIView>(as type: T.Type, config: @escaping (T) -> Void) {
    appendViewConfig {
      if let view = $0 as? T { config(view) }
    }
  }

  public func appendViewDidLoad<T: UIView>(as type: T.Type, config: @escaping (T) -> Void) {
    appendViewDidLoad {
      if let view = $0 as? T { config(view) }
    }
  }
}

open class ViewProducer: ViewProducerType {
  
  public var viewTypeName: String
  public var reuseID: AnyHashable? = nil
  public var viewMaker: (() -> UIView)
  private var _viewConfigs: [(UIView) -> Void] = []
  private var _viewDidLoads: [(UIView) -> Void] = []

  public init<T: UIView>(type: T.Type) {
    viewTypeName = String(describing: type)
    viewMaker = {
      let v = T()
      v.backgroundColor = .clear
      return v
    }
  }

  open var viewConfig: ((UIView) -> ())? {
    guard _viewConfigs.isEmpty == false else {
      return nil
    }
    return { (view) in
      self._viewConfigs.forEach { $0(view) }
    }
  }

  open var viewDidLoad: ((UIView) -> ())? {
    guard _viewDidLoads.isEmpty == false else {
      return nil
    }
    return { (view) in
      self._viewDidLoads.forEach { $0(view) }
    }
  }

  public func appendViewConfig(_ config: @escaping (UIView) -> ()) {
    _viewConfigs.append(config)
  }

  public func appendViewDidLoad(_ config: @escaping (UIView) -> ()) {
    _viewDidLoads.append(config)
  }

}

public protocol ViewProducible {
  associatedtype ProductedView: UIView
}
