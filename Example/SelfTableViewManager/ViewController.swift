//
//  ViewController.swift
//  SelfTableViewManager
//
//  Created by jjfernandes87 on 03/18/2018.
//  Copyright (c) 2018 jjfernandes87. All rights reserved.
//

import UIKit
import SelfTableViewManager

extension NSLayoutConstraint {
    static func pin(_ aView: UIView, to view: UIView, padding: CGFloat = 0) -> PinLayout {

        let left = view.leftAnchor.constraint(equalTo: aView.leftAnchor, constant: padding)
        let right = view.rightAnchor.constraint(equalTo: aView.rightAnchor, constant: padding)
        let top = view.topAnchor.constraint(equalTo: aView.topAnchor, constant: padding)
        let bottom = view.bottomAnchor.constraint(equalTo: aView.bottomAnchor, constant: padding)

        left.isActive = true
        right.isActive = true
        top.isActive = true
        bottom.isActive = true

        return PinLayout(left: left, right: right, top: top, bottom: bottom)
    }
}

class PinLayout: NSObject {
    let left: NSLayoutConstraint
    let right: NSLayoutConstraint
    let top: NSLayoutConstraint
    let bottom: NSLayoutConstraint

    init(left: NSLayoutConstraint, right: NSLayoutConstraint, top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
        super.init()
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: SelfTableViewManager!
    
    var firstTime = true
    var scrollingTableView = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.managerProtocol = self

        var rows = [AnyObject]()
        for value in 1...50 {
            rows.append(CachedCell(value: Double(value)))
        }

        tableView.setRows(rows)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData()
    }

    private func reloadData() {
        if !scrollingTableView {
            tableView.rows.forEach { (cellController) in
                if let cell = cellController as? CachedCell {
                    cell.update()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.reloadData()
        }
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
    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewWillBeginDragging scrollView: UIScrollView) {
        self.scrollingTableView = true
    }

    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewDidEndDecelerating scrollView: UIScrollView) {
        self.scrollingTableView = false
    }
}

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

class CachedCell: CellController {

    var value: Double
    var netChange: Double

    init(value: Double) {
        self.value = value
        self.netChange = value
        super.init()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = loadDefaultCellForTable(tableView: tableView, atIndexPath: indexPath) as! CachedCellView
        cell.accessibilityIdentifier = "cached: \(value)"
        cell.textLabel?.text = "cached: \(value)"
        cell.detailTextLabel?.text = "netChange: \(netChange)"
        controllerCell = cell
        return cell
    }

    func update() {
        if let cell = controllerCell as? CachedCellView, cell.accessibilityIdentifier == "cached: \(value)" {
            self.netChange = self.netChange * 10
            cell.textLabel?.text = "cached: \(value)"
            cell.detailTextLabel?.text = "netChange: \(netChange)"
        }
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

class CachedCellView: CellView {

}
