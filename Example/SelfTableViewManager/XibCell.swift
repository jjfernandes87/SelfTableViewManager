//
//  XPCell.swift
//  SelfTableViewManager_Example
//
//  Created by Julio Fernandes on 29/07/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SelfTableViewManager

@objc(XibCell)
class XibCell: CellController {

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = loadDefaultCellForTable(tableView: tableView, atIndexPath: indexPath) as! XibCellView
        cell.title.text = "cell xp \(indexPath.row)"
        return cell
    }
}

class XibCellView: CellView {
    @IBOutlet weak var title: UILabel!
}
