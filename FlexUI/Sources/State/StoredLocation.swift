//
//  StoredLocation.swift
//  FlexUI
//
//  Created by Li ChangMing on 2021/2/19.
//


final class StoredLocation<Value> {

  private var sinks: [(Value)->()] = []

  var value: Value {
    didSet {
      sinks.forEach {
        $0(value)
      }
    }
  }

  init(_ value: Value) {
    self.value = value
  }

  func observe(_ sink: @escaping (Value)->()) {
    sinks.append(sink)
  }

}
