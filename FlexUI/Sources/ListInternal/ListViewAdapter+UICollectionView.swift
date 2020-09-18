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
    let reg = Registration(id: reuseID, viewClass: customCellClass ??  UICollectionViewCell.self)
    if !resigteredViews.contains(reg) {
      resigteredViews.insert(reg)
      collectionView.registerCell(for: reg.viewClass, reuseID: reg.id)
    }
    let view = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath)
    if isStaticLayout {
      staticLayoutStorage[indexPath.section]?[indexPath.item]?.render(in: view.contentView)
    } else {
      dynamicLayoutStorage[cell]?.render(in: view.contentView)
    }
    return view
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case sectionHeaderKind:
      if let header = data[indexPath.section].header {
        let reuseID = header.typeName
        let reg = Registration(id: reuseID, viewClass: customReusableViewClass ?? UICollectionReusableView.self)
        if !resigteredViews.contains(reg) {
          resigteredViews.insert(reg)
          collectionView.registerHeaderFooterView(for: reg.viewClass, kind: kind, reuseID: reg.id)
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseID, for: indexPath)
        if isStaticLayout {
          staticLayoutStorage[indexPath.section]?[ListViewAdapter.StorageSectionHeaderIndex]?.render(in: view)
        } else {
          dynamicLayoutStorage[header]?.render(in: view)
        }
        return view
      }
    case sectionFooterKind:
      if let footer = data[indexPath.section].footer {
        let reuseID = footer.typeName
        let reg = Registration(id: reuseID, viewClass: customReusableViewClass ?? UICollectionReusableView.self)
        if !resigteredViews.contains(reg) {
          resigteredViews.insert(reg)
          collectionView.registerHeaderFooterView(for: reg.viewClass, kind: kind, reuseID: reg.id)
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseID, for: indexPath)
        if isStaticLayout {
          staticLayoutStorage[indexPath.section]?[ListViewAdapter.StorageSectionFooterIndex]?.render(in: view)
        } else {
          dynamicLayoutStorage[footer]?.render(in: view)
        }
        return view
      }
    default: break
    }
    return  UICollectionReusableView()
  }

}



extension ListViewAdapter: UICollectionViewDelegateFlowLayout {

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if isStaticLayout {
      return staticLayoutStorage[indexPath.section]?[indexPath.item]?.layout?.contentSize ?? .zero
    } else {
      let cell = data[indexPath.section].cells[indexPath.item]
      return dynamicLayoutStorage[cell]?.layout?.contentSize ?? .zero
    }
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    guard let header = data[section].header else {
      return .zero
    }
    if isStaticLayout {
      return staticLayoutStorage[section]?[ListViewAdapter.StorageSectionHeaderIndex]?.layout?.contentSize ?? .zero
    } else {
      return dynamicLayoutStorage[header]?.layout?.contentSize ?? .zero
    }
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    guard let footer = data[section].footer else {
      return .zero
    }
    if isStaticLayout {
      return staticLayoutStorage[section]?[ListViewAdapter.StorageSectionHeaderIndex]?.layout?.contentSize ?? .zero
    } else {
      return dynamicLayoutStorage[footer]?.layout?.contentSize ?? .zero
    }
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if autoDeselect {
      collectionView.deselectItem(at: indexPath, animated: true)
    }
    onSelect?(data[indexPath.section].cells[indexPath.item], indexPath)
  }

}
