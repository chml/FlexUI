//
//  SectionBuilder.swift
//  YogaUI
//
//  Created by Li ChangMing on 2020/8/21.
//


public protocol SectionBuildable {
  func buildSections() -> [Section]
}

extension Section: SectionBuildable {
  public func buildSections() -> [Section] {
    return [self]
  }
}

extension Array: SectionBuildable where Element: SectionBuildable {
  public func buildSections() -> [Section] {
    return map { $0.buildSections() }.flatMap { $0 }
  }
}


extension ListViewAdapter {

  public func render(@SectionBuilder sections: () -> SectionBuildable) {
    render(sections().buildSections())
  }

}

@_functionBuilder
public struct SectionBuilder: SectionBuildable {
  private let sections: [Section]

  init(_ sections: [Section]) {
    self.sections = sections
  }

  public func buildSections() -> [Section] {
    return sections
  }

  public static func buildBlock() -> SectionBuilder {
    return SectionBuilder([])
  }

  public static func buildBlock<Content: SectionBuildable>(_ content: Content) -> Content {
    return content
  }

  public static func buildBlock<Content: SectionBuildable>(_ content: Content?) -> SectionBuildable {
    guard let content = content else {
      return SectionBuilder([])
    }
    return content
  }

  public static func buildBlock<C: Collection>(_ content: C) -> SectionBuildable where C.Element: SectionBuildable {
    return SectionBuilder(content.map { $0.buildSections() }.flatMap { $0 })
  }

  public static func buildBlock(_ content: SectionBuildable...) -> SectionBuilder {
    return SectionBuilder(content.flatMap { $0.buildSections() })
  }

  public static func buildBlock(_ content: SectionBuildable?...) -> SectionBuilder {
    return SectionBuilder(content.compactMap { $0 }.flatMap { $0.buildSections() })
  }

  public static func buildBlock<C: Collection>(_ contents: C) -> SectionBuilder where C.Element: SectionBuildable {
    return SectionBuilder(contents.flatMap { $0.buildSections() })
  }

  public static func buildIf<Content: SectionBuildable>(_ content: Content) -> Content  {
    return content
  }

  public static func buildIf<Content: SectionBuildable>(_ content: Content?) -> Content? {
    return content
  }

  public static func buildEither<TrueContent: SectionBuildable>(first: TrueContent) -> SectionBuilder {
    return SectionBuilder(first.buildSections())
  }

  public static func buildEither<FalseContent: SectionBuildable>(second: FalseContent) -> SectionBuilder {
    return SectionBuilder(second.buildSections())
  }

}
