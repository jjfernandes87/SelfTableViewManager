//
//  ViewController.swift
//  SelfTableViewManager
//
//  Created by jjfernandes87 on 03/18/2018.
//  Copyright (c) 2018 jjfernandes87. All rights reserved.
//

import UIKit
import SelfTableViewManager

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: SelfTableViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rows = [CustomCell(), CustomCell(), CustomCell()]
    }
    
}

@objc(CustomCell)
class CustomCell: CellController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = loadDefaultCellForTable(tableView: tableView, atIndexPath: indexPath) as! CustomCellView
        cell.textLabel?.text = "index: \(indexPath.row)"
        
        return cell
    }
}

class CustomCellView: CellView {
    
}
