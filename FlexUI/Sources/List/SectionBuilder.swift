//
//  SectionBuilder.swift
//  YogaUI
//
//  Created by 黎昌明 on 2020/8/21.
//


public protocol SectionBuildable {
  func buildSections() -> [Section]
}

extension Section: SectionBuildable {
  public func buildSections() -> [Section] {
    return [self]
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

  private init(_ sections: [Section]) {
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
