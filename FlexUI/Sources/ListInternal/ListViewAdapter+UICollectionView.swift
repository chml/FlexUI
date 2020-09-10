//
//  ListViewAdapter+UICollectionView.swift
//  YogaUI
//
//  Created by 黎昌明 on 2020/8/21.
//

import Foundation



extension ListViewAdapter: UICollectionViewDataSource {

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return data.count
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data[section].cells.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = data[indexPath.section].cells[indexPath.item]
    let reuseID = cell.typeName
    let reg = Registration(id: reuseID, viewClass: UICollectionViewCell.self)
    if !resigteredViews.contains(reg) {
      resigteredViews.insert(reg)
      collectionView.registerCell(for: reg.viewClass, reuseID: reg.id)
    }
    let view = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath)
//    layoutStorage[cell]?.makeViews(in: view.contentView)
    return view
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      if let header = data[indexPath.section].header {
        let reuseID = header.typeName
        let reg = Registration(id: reuseID, viewClass: UICollectionReusableView.self)
        if !resigteredViews.contains(reg) {
          resigteredViews.insert(reg)
          collectionView.registerHeaderFooterView(for: reg.viewClass, reuseID: reg.id)
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseID, for: indexPath)
//        layoutStorage[header]?.makeViews(in: view)
        return view
      }
    case UICollectionView.elementKindSectionFooter:
      if let footer = data[indexPath.section].footer {
        let reuseID = footer.typeName
        let reg = Registration(id: reuseID, viewClass: UICollectionReusableView.self)
        if !resigteredViews.contains(reg) {
          resigteredViews.insert(reg)
          collectionView.registerHeaderFooterView(for: reg.viewClass, reuseID: reg.id)
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseID, for: indexPath)
//        layoutStorage[footer]?.makeViews(in: view)
        return view
      }
    default: break
    }
    return UICollectionReusableView()
  }

}



extension ListViewAdapter: UICollectionViewDelegateFlowLayout {

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cell = data[indexPath.section].cells[indexPath.item]
    return .zero
//    return layoutStorage[cell]?.layout?.contentSize ?? .zero
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    guard let header = data[section].header else {
      return .zero
    }
    return .zero
//    return layoutStorage[header]?.layout?.contentSize ?? .zero
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    guard let footer = data[section].footer else {
      return .zero
    }
    return .zero
//    return layoutStorage[footer]?.layout?.contentSize ?? .zero
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if autoDeselect {
      collectionView.deselectItem(at: indexPath, animated: true)
    }
    onSelect?(data[indexPath.section].cells[indexPath.item], indexPath)
  }

}
