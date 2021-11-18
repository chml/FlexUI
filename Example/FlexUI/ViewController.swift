//
//  ViewController.swift
//  FlexUI
//
//  Created by chmlaiii@gmail.com on 08/26/2020.
//  Copyright (c) 2020 chmlaiii@gmail.com. All rights reserved.
//

import UIKit
import FlexUI


private struct Cell: CoordinateNode {
  typealias Body = AnyNode
  
  let title: String

  var isHighlightable: Bool { true }
  var isHighlighted: Bool = false

  let viewController: () -> UIViewController

  init<VC: UIViewController>(_ title: String, _ vc: VC.Type) {
    self.title = title
    self.viewController = { VC() }
  }

  init<VC: UIViewController>(_ title: String, _ vc: @escaping () -> VC) {
    self.title = title
    self.viewController = vc
  }

  func body(with coordinator: Coordinator) -> AnyNode {
    HStack(spacing: 20, alignItems: .center) {
      Text(title)
        .textColor(isHighlighted ? .red : .darkText)
        .flexShrink(1).flexGrow(1)
      Button("Detail") {
        coordinator.onDetailClick?()
      }
      .viewConfig { btn in
        btn.backgroundColor = .gray
      }
    }
    .padding(20)
    .asAnyNode
  }

  final class Coordinator: NodeCoordinator {
    
    var onDetailClick: (() -> ())? = nil

    override func didLoad() {
    }
  }
}

final class ViewController: UIViewController {


  override func viewDidLoad() {
    super.viewDidLoad()
    title = "FlexUI"
    flex.render {
      List {
        Section(id: AnyHashable(0), header: Text("Basic")) {
          Cell("Flexbox Layout", FlexboxViewController.self)
          Cell("Diffable TableView", DiffTableViewController.self)
          Cell("Diffable CollectionView", DiffCollectionViewController.self)
          Cell("Playground", PlaygroundViewController.self)
//          Cell("NodeView && AutoLayout", NodeViewViewController.self)
        }
        Section(id: AnyHashable(1), header: Text("Demo")) {
          Cell("Counter", CounterDemoViewController.self)
          Cell("User Profile ", UserProfileViewController.self)
          Cell("AirBnB/MagazineLayout", MagazineLayoutViewController.self)
          Cell("Live Room", LiveRoomsListViewController.self)
          Cell("Benchmark") {
            FlexUICollectionViewController(data: FeedItemData.generate(count: 200))
          }
        }
      }
      .onSelect {[weak self] (item) in
        if let cell = item.unwrap(as: Cell.self) {
          //          if cell.title == "Benchmark" {
          //            let viewControllerData = ViewControllerData(title: cell.title) {
          ////              print("ViewControllerData \($0)")
          //              return FlexUICollectionViewController(data: FeedItemData.generate(count: $0))
          //            }
          //            self?.runBenchmark(viewControllerData: viewControllerData, logResults: true, completed: { [weak self] (results) in
          //              self?.printResults(name: viewControllerData.title, results: results)
          //            })
          //            return
          //          }
          self?.navigationController?.pushViewController(cell.viewController(), animated: true)
        }
      }
      .width(.percent(100))
      .height(.percent(100))
    }
  }

  private func printResults(name: String, results: [Result]) {
    var resultsString = "\(name)\t"
    results.forEach { (result) in
      resultsString += "\(result.secondsPerOperation)\t"
    }
    print(resultsString)
  }

  private func runBenchmark(viewControllerData: ViewControllerData, logResults: Bool, completed: ((_ results: [Result]) -> Void)?) {
    guard let viewController = viewControllerData.factoryBlock(100) else {
      return
    }

    benchmark(viewControllerData, logResults: logResults, completed: completed)

    viewController.title = viewControllerData.title
    navigationController?.pushViewController(viewController, animated: logResults)
  }

  private func benchmark(_ viewControllerData: ViewControllerData, logResults: Bool, completed: ((_ results: [Result]) -> Void)?) {
    //        let iterations = [1]
    let iterations = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    var results: [Result] = []

    for i in iterations {
      let description = "\(i)\tsubviews\t\(viewControllerData.title)"
      let result = Stopwatch.benchmark(description, logResults: logResults, block: { (stopwatch: Stopwatch) -> Void in
        let vc = viewControllerData.factoryBlock(i)
        stopwatch.resume()
        //        vc?.view.layoutIfNeeded()
        self.navigationController?.pushViewController(vc!, animated: false)
        stopwatch.pause()
        self.navigationController?.popViewController(animated: false)
      })
      
      results.append(result)
    }

    completed?(results)
  }

}

private struct ViewControllerData {
  let title: String
  let factoryBlock: (_ viewCount: Int) -> UIViewController?
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct ViewController_Preview: PreviewProvider {
  static var previews: some View {
    return UIViewControllerPreview(ViewController())
  }
}
#endif
