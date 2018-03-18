//
//  TestViewController.swift
//  SelfTableViewManager
//
//  Created by Julio Fernandes on 18/03/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SelfTableViewManager

class TestViewController: UIViewController {
    
    @IBOutlet weak var tableView: SelfTableViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.managerProtocol = self
    }
}

extension TestViewController: TableViewManagerDelegate {
    
}

@objc(CustomTestCell)
class CustomTestCell: CellController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = loadDefaultCellForTable(tableView: tableView, atIndexPath: indexPath) as! CustomTestCellView
        cell.label.text = "index: \(indexPath.item)"
        return cell
    }
    
}

class CustomTestCellView: CellView {
    @IBOutlet weak var label: UILabel!
}


