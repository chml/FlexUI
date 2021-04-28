//
//  LivePreview.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/17.
//

#if canImport(SwiftUI)
import UIKit
import SwiftUI

@available(iOS 13.0, *)
public struct UIViewControllerPreview: View, UIViewControllerRepresentable {
  public typealias UIViewControllerType = UIViewController

  private let maker: () -> UIViewController

  public init(_ maker: @escaping () -> UIViewController) {
    self.maker = maker
  }

  public init(_ viewController: UIViewController) {
    maker = { viewController }
  }

  public func makeUIViewController(context: Context) -> UIViewController {
    maker()
  }

  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
  }
}


@available(iOS 13.0, *)
public struct UIViewPreview: View, UIViewRepresentable {

  public enum Layout {
    case fitWidth(CGFloat = 414)
    case fitHeight(CGFloat = 896)
    case `default`
  }

  public typealias UIViewType = UIView

  private let maker: () -> UIView
  private let layout: Layout

  public init(_ layout: Layout = .default, _ maker: @escaping () -> UIView) {
    self.layout = layout
    self.maker = maker
  }

  public init(_ layout: Layout = .default, _ view: UIView) {
    self.layout = layout
    self.maker = { view }
  }


  public func makeUIView(context: Context) -> UIView {
    let v = PreviewView(layout: layout, content: maker())
    v.invalidateIntrinsicContentSize()
    return v
  }

  public func updateUIView(_ view: UIView, context: Context) {
    view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
}

@available(iOS 13.0, *)
final class PreviewView: UIView {
  typealias Layout = UIViewPreview.Layout
  let content: UIView
  private let layout: Layout
  private var contentIntrinsicContentSize: CGSize? = nil
  override var intrinsicContentSize: CGSize {
    contentIntrinsicContentSize ?? super.intrinsicContentSize
  }

  override func invalidateIntrinsicContentSize() {
    contentIntrinsicContentSize = calculateContentSize()
    super.invalidateIntrinsicContentSize()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  init(layout: Layout, content: UIView) {
    self.layout = layout
    self.content = content
    super.init(frame: .zero)
    addSubview(content)
    translatesAutoresizingMaskIntoConstraints = false
    content.translatesAutoresizingMaskIntoConstraints = false

    contentIntrinsicContentSize = calculateContentSize()
    NSLayoutConstraint.activate( [
      content.leadingAnchor.constraint(equalTo: leadingAnchor).withPriority(.required),
      content.trailingAnchor.constraint(equalTo: trailingAnchor).withPriority(.required),
      content.topAnchor.constraint(equalTo: topAnchor).withPriority(.required),
      content.bottomAnchor.constraint(equalTo: bottomAnchor).withPriority(.required),
    ])
    switch layout {
    case let .fitWidth(value):
      NSLayoutConstraint.activate( [
        content.widthAnchor.constraint(lessThanOrEqualToConstant: value).withPriority(.required)
      ])
      content.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    case let .fitHeight(value):
      NSLayoutConstraint.activate( [
        content.heightAnchor.constraint(lessThanOrEqualToConstant: value).withPriority(.required)
      ])
      content.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    default: break
    }
  }


  private func calculateContentSize() -> CGSize {
    var width = CGFloat.greatestFiniteMagnitude
    var height = CGFloat.greatestFiniteMagnitude
    var horizontalFittingPriority = UILayoutPriority.fittingSizeLevel
    var verticalFittingPriority = UILayoutPriority.fittingSizeLevel

    switch layout {
    case let .fitWidth(value):
      width = value
      horizontalFittingPriority = .required
    case let .fitHeight(value):
      height = value
      verticalFittingPriority = .required
    default: break
    }

    return content.systemLayoutSizeFitting(
      CGSize(width: width, height: height),
      withHorizontalFittingPriority: horizontalFittingPriority,
      verticalFittingPriority: verticalFittingPriority
    )
  }
}

public final class PreviewTableViewController<Item, Cell: UITableViewCell>: UIViewController, UITableViewDataSource {
  public var items: [Item] {
    didSet {
      tableView.reloadData()
    }
  }
  public lazy var tableView: UITableView = {
    UITableView(frame: .zero, style: tableStyle)
  } ()
  public var config: (_ cell: Cell, _ item: Item)->()
  private let tableStyle: UITableView.Style

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  public init(style: UITableView.Style = .plain, items:[Item], cell: Cell.Type, config: @escaping (_ cell: Cell, _ item: Item)->()) {
    self.tableStyle = style
    self.items = items
    self.config = config
    super.init(nibName: nil, bundle: nil)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.register(Cell.self, forCellReuseIdentifier: "cell")
    tableView.dataSource = self
    tableView.reloadData()
  }

  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableView.frame = view.bounds
  }

  public func numberOfSections(in tableView: UITableView) -> Int { 1 }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Cell {
      config(cell, items[indexPath.item])
      return cell
    }
    return .init()
  }

}

extension UIViewController {
  public func withNavigationController(_ title: String? = nil) -> UINavigationController {
    self.title = title
    return .init(rootViewController: self)
  }
}

extension NSLayoutConstraint {
  public func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    return self
  }
}

#endif

