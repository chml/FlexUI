//
//  State.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/8/31.
//


public protocol DynamicProperty {
  func update()
}

extension DynamicProperty {
  public func update() {
  }
}

@propertyWrapper
public struct State<Value>: DynamicProperty {

  final class Storage {
    var value: Value

    init(value: Value) {
      self.value = value
    }
  }

  private let storage: Storage

  public init(wrappedValue value: Value) {
    self.storage = .init(value: value)
  }

  public init(initialValue value: Value) {
    self.storage = .init(value: value)
  }

  public var wrappedValue: Value {
    get { return storage.value }
    nonmutating set { storage.value = newValue }
  }

  public var projectedValue: Binding<Value> {
    return Binding(get: { return self.wrappedValue }, set: { newValue in self.wrappedValue = newValue })
  }

}

extension State where Value: ExpressibleByNilLiteral {
  public init() {
    self.init(wrappedValue: nil)
  }
}
