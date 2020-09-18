//
//  ListViewAdapter+UITableView.swift
//  YogaUI
//
//  Created by 黎昌明 on 2020/8/21.
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
    let cell = data[indexPath.section].cells[indexPath.item]
    let reuseID = cell.typeName
    if let view = tableView.dequeueReusableCell(withIdentifier: reuseID) {
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
    onSelect?(data[indexPath.section].cells[indexPath.item], indexPath)
  }

  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let header = data[section].header {
      let reuseID = header.typeName
      if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID) {
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
    if let footer = data[section].footer {
      let reuseID = footer.typeName
      if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID) {
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


}
