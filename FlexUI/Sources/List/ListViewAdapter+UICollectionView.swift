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
    layoutStorage.tree(forCellAt: indexPath).makeViews(in: view.contentView)
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
        layoutStorage.tree(forHeaderAt: indexPath.section).makeViews(in: view)
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
        layoutStorage.tree(forFooterAt: indexPath.section).makeViews(in: view)
        return view
      }
    default: break
    }
    return UICollectionReusableView()
  }

}



extension ListViewAdapter: UICollectionViewDelegateFlowLayout {

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return layoutStorage.tree(forCellAt: indexPath).layout?.contentSize ?? .zero
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    guard data[section].header != nil else {
      return .zero
    }
    return layoutStorage.tree(forHeaderAt: section).layout?.contentSize ?? .zero
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    guard data[section].footer != nil else {
      return .zero
    }
    return layoutStorage.tree(forFooterAt: section).layout?.contentSize ?? .zero
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if autoDeselect {
      collectionView.deselectItem(at: indexPath, animated: true)
    }
    onSelect?(data[indexPath.section].cells[indexPath.item], indexPath)
  }

}
