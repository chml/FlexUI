//
//  State.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/31.
//


public protocol DynamicProperty {
}

@propertyWrapper
public struct State<Value>: DynamicProperty {

  let _location: StoredLocation<Value>
  weak var _flexNode: FlexNode? {
    didSet {
      _location.observe { [weak _flexNode] (_) in
//        _flexNode?.coordinator
      }
    }
  }

  public var wrappedValue: Value {
    get { _location.value }
    set { _location.value = newValue }
  }

  public init(wrappedValue: Value) {
    _location = StoredLocation(wrappedValue)
  }


}

//extension State where Value: ExpressibleByNilLiteral {
//  public init() {
//    self.init(wrappedValue: nil)
//  }
//}
