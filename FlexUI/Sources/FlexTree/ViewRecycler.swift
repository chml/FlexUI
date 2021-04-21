//
//  ViewRecycler.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/2.
//

import UIKit

final class ViewRecycler {

  private var viewsByID: [AnyHashable: UIView] = .init()
  private var unidentifiedViewsByType: [String: [UIView]] = .init()
  private var recyclingViewsByID: [AnyHashable: UIView] = .init()
  private var recyclingUnidentifiedViewsByType: [String: [UIView]] = .init()

  private weak var rootView: UIView?

  static func recycler(for rootView: UIView) -> ViewRecycler {
    if let recycler = rootView.subviewRecycler {
//      print("Hit recycler")
      return recycler
    }
//    print("Miss recycler")
    let recycler = ViewRecycler(rootView: rootView)
    rootView.subviewRecycler = recycler
    return recycler
  }

  private init(rootView: UIView) {
    self.rootView = rootView
  }

  func prepareRecycling() {
    recyclingViewsByID.removeAll()
    recyclingUnidentifiedViewsByType.removeAll()
  }

  func flush() {
//    print("Flush viewsByID:\(viewsByID.count), recyclingViewsByID: \(recyclingViewsByID.count)")
    viewsByID.forEach { (_, view) in
       // TODO: fade out
      view.removeFromSuperview()
    }
    viewsByID = recyclingViewsByID

//    print("Flush viewsByType:\(unidentifiedViewsByType.count), recyclingViewsByType: \(recyclingUnidentifiedViewsByType.count)")
    unidentifiedViewsByType.forEach { (_, set) in
      set.forEach {
        // TODO: fade out
        $0.removeFromSuperview()
      }
    }
    unidentifiedViewsByType = recyclingUnidentifiedViewsByType
  }

  func makeOrRecycleView(for node: FlexNode, parentView: UIView? = nil) -> UIView {
    guard let viewProducer = node.viewProducer else {
      return UIView()
    }

    if let reuseID = viewProducer.reuseID {
      if let recycled = viewsByID[reuseID]{
        viewsByID.removeValue(forKey: reuseID)
        recyclingViewsByID[reuseID] = recycled
//        print("Hit \(reuseID)")
        recycled.transform = .identity
        return recycled
      } else {
//        print("Miss \(reuseID)")
        let view = viewProducer.viewMaker()
        recyclingViewsByID[reuseID] = view
        return view
      }
    }

    let viewType = viewProducer.viewTypeName
    if let view = getViewFromTypeMap(&unidentifiedViewsByType, for: viewType) {
      insertViewToTypeMap(&recyclingUnidentifiedViewsByType, for: viewType, view: view)
      view.transform = .identity
      return view
    } else {
      let view = viewProducer.viewMaker()
      insertViewToTypeMap(&recyclingUnidentifiedViewsByType, for: viewType, view: view)
      return view
    }

  }

  private func getViewFromTypeMap(_ map: inout [String: [UIView]], for type: String) -> UIView? {
    if var views = map[type] {
      if let view = views.last {
        views.removeLast()
        map[type] = views
        return view
      }
    }
    return nil
  }

  private func insertViewToTypeMap(_ map: inout [String: [UIView]], for type: String, view: UIView) {
    if var views = map[type] {
      views.append(view)
      map[type] = views
    } else {
      var views = [UIView]()
      views.append(view)
      map[type] = views
    }
  }

}

extension UIView {

  private struct AssociatedKey {
    static var recycler: UInt8 = 0
  }

  var subviewRecycler: ViewRecycler? {
    get { objc_getAssociatedObject(self, &AssociatedKey.recycler) as? ViewRecycler }
    set { objc_setAssociatedObject(self, &AssociatedKey.recycler, newValue, .OBJC_ASSOCIATION_RETAIN) }
  }

}
