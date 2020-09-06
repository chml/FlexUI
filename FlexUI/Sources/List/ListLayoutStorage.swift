//
//  ListLayoutStorage.swift
//  FlexUI
//
//  Created by 黎昌明 on 2020/9/6.
//


final class ListLayoutStorage {

  static private var HeaderIndex: Int = -1
  static private var FooterIndex: Int = -2

  var storage: [Int: [Int: FlexTree]] = .init()


  func setTree(_ tree: FlexTree, forCellAt indexPath: IndexPath) {
    storage[indexPath.section, default: [:]][indexPath.item] = tree
  }

  func setTree(_ tree: FlexTree, forHeaderAt section: Int) {
    storage[section, default: [:]][ListLayoutStorage.HeaderIndex] = tree
  }

  func setTree(_ tree: FlexTree, forFooterAt section: Int) {
    storage[section, default: [:]][ListLayoutStorage.FooterIndex] = tree
  }

  func tree(forCellAt indexPath: IndexPath) -> FlexTree {
    return (storage[indexPath.section]?[indexPath.item])!
  }

  func tree(forHeaderAt section: Int) -> FlexTree {
    return (storage[section]?[ListLayoutStorage.HeaderIndex])!
  }

  func tree(forFooterAt section: Int) -> FlexTree {
    return (storage[section]?[ListLayoutStorage.FooterIndex])!
  }

  func deleteTree(forCellAt indexPath: IndexPath) {
    storage[indexPath.section, default: [:]][indexPath.item] = nil
  }

  func deleteTrees(forSection section: Int) {
    storage[section] = nil
  }

  func moveCell(from: IndexPath, to: IndexPath) {
  }

  func moveSection(from: Int, to: Int ) {
  }


}

