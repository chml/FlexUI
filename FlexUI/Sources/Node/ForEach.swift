//
//  ForEach.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/9/3.
//


public struct ForEach<Data: RandomAccessCollection, Content: Node>: Node {
  public typealias Body = Never

  let data: Data
  let content: (Data.Element) -> Content

  public init(_ data: Data, @NodeBuilder content: @escaping (Data.Element) -> Content) {
    self.data = data
    self.content = content
  }
}

extension ForEach {

  public func build(with context: YogaTreeContext) -> [YogaNode] {
    data.map { (elem) -> [YogaNode] in
      content(elem).build(with: context)
    }
    .flatMap { $0 }
  }

}
