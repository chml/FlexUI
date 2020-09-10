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
      if isStaticLayout {
        staticLayoutStorage[indexPath.section]?[indexPath.item]?.render(in: view.contentView)
      } else {
        dynamicLayoutStorage[cell.id]?.render(in: view.contentView)
      }
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
    onSelect?(data[indexPath.section].cells[indexPath.item], indexPath)
  }

  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let header = data[section].header {
      let reuseID = header.typeName
      if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID) {
        if isStaticLayout {
          staticLayoutStorage[section]?[ListViewAdapter.StorageSectionHeaderIndex]?.render(in: view.contentView)
        } else {
          dynamicLayoutStorage[header.id]?.render(in: view.contentView)
        }
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
      let reuseID = footer.typeName
      if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID) {
        if isStaticLayout {
          staticLayoutStorage[section]?[ListViewAdapter.StorageSectionFooterIndex]?.render(in: view.contentView)
        } else {
          dynamicLayoutStorage[footer.id]?.render(in: view.contentView)
        }
        return view
      } else {
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseID)
        return self.tableView(tableView, viewForHeaderInSection: section)
      }
    }
    return UIView()
  }

  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if let header = data[section].header {
      if isStaticLayout {
        return staticLayoutStorage[section]?[ListViewAdapter.StorageSectionHeaderIndex]?.layout?.contentSize.height ?? 0
      } else {
        return dynamicLayoutStorage[header.id]?.layout?.contentSize.height ?? 0
      }
    }
    return 0
  }

  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if let footer = data[section].header {
      if isStaticLayout {
        return staticLayoutStorage[section]?[ListViewAdapter.StorageSectionFooterIndex]?.layout?.contentSize.height ?? 0
      } else {
        return dynamicLayoutStorage[footer.id]?.layout?.contentSize.height ?? 0
      }
    }
    return 0
  }

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if isStaticLayout {
      return staticLayoutStorage[indexPath.section]?[indexPath.item]?.layout?.contentSize.height ?? 0
    } else {
      let cell = data[indexPath.section].cells[indexPath.item]
      return dynamicLayoutStorage[cell.id]?.layout?.contentSize.height ?? 0
    }
  }


}
