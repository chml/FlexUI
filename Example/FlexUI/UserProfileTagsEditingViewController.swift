//
//  UserProfileTagsEditingViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI


@propertyWrapper
struct EqualableClosure<Value> {

  final class Storage<T>: Equatable {
    static func == (lhs: EqualableClosure<Value>.Storage<T>, rhs: EqualableClosure<Value>.Storage<T>) -> Bool {
      return lhs === rhs
    }

    var value: T

    init(value: T) {
      self.value = value
    }
  }
  private let storage: Storage<Value>

  init(wrappedValue value: Value) {
    self.storage = .init(value: value)
  }

  public init(initialValue value: Value) {
    self.storage = .init(value: value)
  }

  public var wrappedValue: Value {
    get { return storage.value }
    nonmutating set { storage.value = newValue }
  }

  public var projectedValue: Storage<Value> {
    return self.storage
  }

}


private struct TagCell: Component {

  typealias Body = AnyNode

  var id: AnyHashable {
    return editingText.hashValue
  }

  func isContentEqual(to other: TagCell) -> Bool {
    return editingText === other.editingText && $onDelete === other.$onDelete
  }

  var editingText: EditingText
  @EqualableClosure var onDelete: ((TagCell)->())

  func body(with coordinator: Coordinator) -> AnyNode {
    View(of: UITextField.self)
      .maxWidth(.percent(100))
      .height(40)
      .viewMaker { () -> UIView in
        let v = UITextField()
        v.borderStyle = .roundedRect
        return v
    }
    .viewConfig { (v) in
      v.text = self.editingText.text
      v.removeTarget(coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
      v.addTarget(coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
    }
    .overlay {
      Button("X") {
        self.onDelete(self)
      }
      .width(25).height(25)
      .end(-12).top(-12)
    }
    .margin(12)
    .asAnyNode
  }

  final class Coordinator: ComponentCoordinator {
    typealias Content = TagCell
    let context: Context
    init(with context: Context) {
      self.context = context
    }

    @objc
    func textChanged(_ sender: UITextField) {
      context.current().editingText.text = sender.text ?? ""
    }

  }
}

final class UserProfileTagsEditingViewController: UIViewController, Component {
  typealias Body = AnyNode

  var tags: [EditingText]
  var onSave:((_ tags: [String]) -> Void)? = nil

  init(title: String, tags: [String]) {
    self.tags = tags.map {
      EditingText($0)
    }
    super.init(nibName: nil, bundle:nil)
    self.title = title
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
    navigationItem.rightBarButtonItem = save
    flex.render()
  }

  @objc
  func save(_ sender: UIBarButtonItem) {
    onSave?(tags.map { $0.text })
    self.dismiss(animated: true, completion: nil)
  }

  func body(with coordinator: SimpleCoordinator<UserProfileTagsEditingViewController>) -> AnyNode {
    List(table: .grouped, data: self.tags) {
      TagCell(editingText: $0, onDelete: { (tag) in
        print("onDelete \(Unmanaged.passUnretained(coordinator).toOpaque())")
        coordinator.update { (vc) in
          let index = vc.tags.firstIndex(of: tag.editingText)!
          vc.tags.remove(at: index)
        }
      })
    }
    .width(.percent(100))
    .height(.percent(100))
    .asAnyNode
  }

}
