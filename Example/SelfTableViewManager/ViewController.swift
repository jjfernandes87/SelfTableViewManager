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
        tableView.managerProtocol = self
        tableView.setRows([CustomCell(), CustomCell(), CustomCell(), XibCell(), CustomCell(), CustomCell(), CustomCell(), XibCell(), CustomCell(), CustomCell(), CustomCell(), XibCell(), CustomCell(), CustomCell(), CustomCell(), XibCell(), CustomCell(), CustomCell(), CustomCell(), XibCell(), CustomCell(), CustomCell(), CustomCell(), XibCell()])
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

extension ViewController: TableViewManagerDelegate {
    func tableViewManager(table: SelfTableViewManager, scrollView: UIScrollView, didChangeScrollOffset newOffset: CGPoint) {
        print(newOffset)
    }
}

@objc(CustomCell)
class CustomCell: CellController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = loadDefaultCellForTable(tableView: tableView, atIndexPath: indexPath) as! CustomCellView
        cell.textLabel?.text = "index: \(indexPath.row)"
        
        return cell
    }

    override func tableView(tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .normal, title: "share") { (action, indexPath) in
            print(action)
        }
        return [share]
    }

    override func tableView(tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class CustomCellView: CellView {
    
}
