//
//  UserProfileTagsEditingViewController.swift
//  FlexUI_Example
//
//  Created by 黎昌明 on 2020/9/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

private struct TagCell: Component, Hashable {

  typealias Body = AnyNode

  var id: AnyHashable {
    return editingText.hashValue
  }

  var editingText: EditingText

  func body(with coordinator: Coordinator) -> AnyNode {
    View(of: UITextField.self)
      .maxWidth(.percent(100))
      .height(40)
      .viewMaker({ () -> UIView in
        let v = UITextField()
        v.borderStyle = .roundedRect
        v.removeTarget(coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
        v.addTarget(coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
        return v
      })
      .viewConfig { (v) in
        v.text = self.editingText.text
    }
    .overlay({
      View(of: UIButton.self)
        .width(20).height(20)
        .end(-10).top(-10)
        .viewMaker ({ () -> UIView in
          UIButton(type: .close)
        })
        .viewConfig { (v) in
          v.removeTarget(coordinator, action: #selector(Coordinator.delete(_:)), for: .touchUpInside)
          v.addTarget(coordinator, action: #selector(Coordinator.delete(_:)), for: .touchUpInside)
      }
    })
      .margin(12)
      .asAnyNode
  }

  final class Coordinator: ComponentCoordinator {
    typealias Content = TagCell
    let context: Context
    var onDelete: ((Content)->())? = nil
    init(with context: Context) {
      self.context = context
    }

    @objc
    func delete(_ sender: UIButton) {
      onDelete?(context.current())
    }

    @objc
    func textChanged(_ sender: UITextField) {
      context.current().editingText.text = sender.text ?? ""
    }

  }
}

final class UserProfileTagsEditingViewController: UIViewController {

  var tags: [EditingText] {
    didSet {
      render()
    }
  }
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
    render()
  }

  @objc
  func save(_ sender: UIBarButtonItem) {
    onSave?(tags.map { $0.text })
    self.dismiss(animated: true, completion: nil)
  }

  private func render() {
    view.render(node:
      List(table: .grouped) {
        ForEach(self.tags) {
          TagCell(editingText: $0)
        }
      }
      .width(.percent(100))
      .height(.percent(100))
      .asAnyNode
    )
  }

}
