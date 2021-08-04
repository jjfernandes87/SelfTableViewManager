//
//  ViewCodeCell.swift
//  SelfTableViewManager_Tests
//
//  Created by Valmir Massoni on 04/08/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import SelfTableViewManager

final class ViewCodeCell: CellController {

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = loadDefaultCellForTable(tableView: tableView, atIndexPath: indexPath) as? ViewCodeCellView else {
            return UITableViewCell()
        }
        return cell
    }
}

final class ViewCodeCellView: CellView {}

