//
//  ListViewAdapter+UITableView.swift
//  YogaUI
//
//  Created by Li ChangMing on 2020/8/21.
//

import Foundation

@objc extension ListViewAdapter: UITableViewDataSource {

  public func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].cells.count
  }


  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = itemCell(at: indexPath)
    let reuseID = cell.typeName
    if let view = tableView.dequeueReusableCell(withIdentifier: reuseID) {
      view.backgroundColor = .clear
      treeForItem(at: indexPath)?.render(in: view.contentView)
      view.transform = CGAffineTransform(scaleX: 1, y: reversed ? -1 : 1)
      return view
    } else {
      tableView.register(customCellClass ?? UITableViewCell.self, forCellReuseIdentifier: reuseID)
      return self.tableView(tableView, cellForRowAt: indexPath)
    }
  }

}

@objc extension ListViewAdapter: UITableViewDelegate {

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if autoDeselect {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    onSelect?(itemCell(at: indexPath), indexPath)
  }

  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let header = sectionHeader(at: section) {
      let reuseID = header.typeName
      if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID) {
        view.backgroundColor = .clear
        treeForHeader(at: section)?.render(in: view.contentView)
        view.transform = CGAffineTransform(scaleX: 1, y: reversed ? -1 : 1)
        return view
      } else {
        tableView.register(customReusableViewClass ?? UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseID)
        return self.tableView(tableView, viewForHeaderInSection: section)
      }
    }
    return UIView()
  }

  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if let footer = sectionFooter(at: section) {
      let reuseID = footer.typeName
      if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID) {
        view.backgroundColor = .clear
        treeForFooter(at: section)?.render(in: view.contentView)
        view.transform = CGAffineTransform(scaleX: 1, y: reversed ? -1 : 1)
        return view
      } else {
        tableView.register(customReusableViewClass ?? UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseID)
        return self.tableView(tableView, viewForHeaderInSection: section)
      }
    }
    return UIView()
  }

  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return treeForHeader(at: section)?.layout?.contentSize.height ?? 0
  }

  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return treeForFooter(at: section)?.layout?.contentSize.height ?? 0
  }

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return treeForItem(at: indexPath)?.layout?.contentSize.height ?? 0
  }

  public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
  }

  public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
  }

}

