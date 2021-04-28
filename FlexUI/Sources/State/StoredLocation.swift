//
//  StoredLocation.swift
//  FlexUI
//
//  Created by Li ChangMing on 2021/2/19.
//


final class StoredLocation<Value> {
  typealias ObserveToken = UInt

  private var sinks: [ObserveToken: (Value)->()] = [:]
  private var observeTokenSeed: UInt = 1

  var value: Value {
    didSet {
      sinks.forEach { $0.value(value) }
    }
  }

  init(_ value: Value) {
    self.value = value
  }

  func observe(_ sink: @escaping (Value)->()) -> ObserveToken {
    observeTokenSeed += 1
    let token = observeTokenSeed
    sinks[token] = sink
    return token
  }

  func removeObserve(_ token: ObserveToken) {
    sinks.removeValue(forKey: token)
  }

}
