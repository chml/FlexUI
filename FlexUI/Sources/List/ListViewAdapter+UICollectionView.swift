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
    return UICollectionViewCell()
  }
}



extension ListViewAdapter: UICollectionViewDelegateFlowLayout {

}
