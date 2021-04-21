//
//  ListViewAdapter+UICollectionView.swift
//  YogaUI
//
//  Created by Li ChangMing on 2020/8/21.
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
    let cell = itemCell(at: indexPath)
    let reuseID = cell.typeName
    let reg = Registration(id: reuseID, viewClass: customCellClass ??  UICollectionViewCell.self)
    if !resigteredViews.contains(reg) {
      resigteredViews.insert(reg)
      collectionView.registerCell(for: reg.viewClass, reuseID: reg.id)
    }
    let view = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath)
    treeForItem(at: indexPath)?.render(in: view.contentView)
    return view
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case sectionHeaderKind:
      if let header = sectionHeader(at: indexPath.section) {
        let reuseID = header.typeName
        let reg = Registration(id: reuseID, viewClass: customReusableViewClass ?? UICollectionReusableView.self)
        if !resigteredViews.contains(reg) {
          resigteredViews.insert(reg)
          collectionView.registerHeaderFooterView(for: reg.viewClass, kind: kind, reuseID: reg.id)
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseID, for: indexPath)
        treeForHeader(at: indexPath.section)?.render(in: view)
        return view
      }
    case sectionFooterKind:
      if let footer = sectionFooter(at: indexPath.section) {
        let reuseID = footer.typeName
        let reg = Registration(id: reuseID, viewClass: customReusableViewClass ?? UICollectionReusableView.self)
        if !resigteredViews.contains(reg) {
          resigteredViews.insert(reg)
          collectionView.registerHeaderFooterView(for: reg.viewClass, kind: kind, reuseID: reg.id)
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseID, for: indexPath)
        treeForFooter(at: indexPath.section)?.render(in: view)
        return view
      }
    default: break
    }
    return  UICollectionReusableView()
  }

}



extension ListViewAdapter: UICollectionViewDelegateFlowLayout {

  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return treeForItem(at: indexPath)?.layout?.contentSize ?? .zero
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return treeForHeader(at: section)?.layout?.contentSize ?? .zero
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return treeForFooter(at: section)?.layout?.contentSize ?? .zero
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if autoDeselect {
      collectionView.deselectItem(at: indexPath, animated: true)
    }
    onSelect?(data[indexPath.section].cells[indexPath.item], indexPath)
  }

}
