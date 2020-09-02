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
    let reuseID = cell.reuseID
    if let view = tableView.dequeueReusableCell(withIdentifier: reuseID) {
      cell.tree.makeViews(in: view.contentView)
      return view
    } else {
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
      return self.tableView(tableView, cellForRowAt: indexPath)
    }
  }

}

@objc extension ListViewAdapter: UITableViewDelegate {

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if autoDeselect {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    onSelect?(data[indexPath.section].cells[indexPath.item].node, indexPath)
  }

  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let header = data[section].header {
      let reuseID = header.reuseID
      if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID) {
        header.tree.makeViews(in: view.contentView)
        return view
      } else {
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseID)
        return self.tableView(tableView, viewForHeaderInSection: section)
      }
    }
    return UIView()
  }

  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if let footer = data[section].footer {
      let reuseID = footer.reuseID
      if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID) {
        footer.tree.makeViews(in: view.contentView)
        return view
      } else {
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseID)
        return self.tableView(tableView, viewForHeaderInSection: section)
      }
    }
    return UIView()
  }

  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if let layout = data[section].header?.tree.layout {
      return layout.contentSize.height
    }
    return 0
  }

  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if let layout = data[section].footer?.tree.layout {
      return layout.contentSize.height
    }
    return 0
  }

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if let layout = data[indexPath.section].cells[indexPath.item].tree.layout {
      return layout.contentSize.height
    }
    return 40
  }


}
