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
    
    var firstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setRows([CustomCell(), CustomCell(), CustomCell()])
    }
    
    @IBAction func addCell() {
        if firstTime {
            firstTime = false
            tableView.insertRowsOnTop(rows: [CustomCell(), CustomCell(), CustomCell()], animation: .automatic)
        } else {
            tableView.insertRows(rows: [CustomCell(), CustomCell(), CustomCell()], at: 1, animation: .automatic)
        }
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
