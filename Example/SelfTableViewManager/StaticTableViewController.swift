//
//  StaticTableViewController.swift
//  SelfTableViewManager_Example
//
//  Created by Julio Fernandes on 11/08/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SelfTableViewManager

class StaticTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: SelfTableViewManagerStatic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setSectionsAndRows = [StaticSectionCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell(), StaticCustomCell()]
    }
    
}

class StaticCustomCell: CellController {
    
    var defaultSize: CGFloat    = 112
    var currentSize: CGFloat    = 0
    var maxSize: CGFloat        = 0
    
    var batchUpdates = false
    
    override init() {
        self.currentSize = self.defaultSize
        self.maxSize = self.defaultSize
        super.init()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = loadDefaultCellForTable(tableView: tableView, atIndexPath: indexPath) as! StaticCustomCellView
        let angle: CGFloat = self.currentSize == self.defaultSize ? 2 : 1
        cell.icon.transform = CGAffineTransform(rotationAngle: CGFloat.pi * angle)
        
        cell.label.text = "index: \(indexPath.row)"
        cell.detail.sizeToFit()
        self.maxSize = cell.detail.frame.size.height + self.defaultSize + 40
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentSize
    }
    
    override func tableView(tableView: UITableView, didSelectThisCellAtIndexPath indexPath: IndexPath) {
        self.currentSize = self.currentSize == self.defaultSize ? self.maxSize : self.defaultSize
        self.reloadMe(animation: .fade)
    }
        
    //        if !batchUpdates {
    //            self.batchUpdates = true
    //            self.currentSize = self.currentSize == self.defaultSize ? self.maxSize : self.defaultSize
    //            if #available(iOS 11.0, *) {
    //                if self.currentSize != self.defaultSize {
    //                    tableView.performBatchUpdates({ self.reloadMe(animation: .automatic) })
    //                    { (finished) in
    //                        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    //                        self.batchUpdates = false
    //                    }
    //                } else {
    //                    tableView.performBatchUpdates({ tableView.scrollToRow(at: indexPath, at: .top, animated: true) })
    //                    { (finished) in
    //                        self.reloadMe(animation: .automatic)
    //                        self.batchUpdates = false
    //                    }
    //                }
    //            } else {
    //                self.reloadMe(animation: .automatic)
    //                self.batchUpdates = false
    //            }
    //
    //        }
    
}

class StaticCustomCellView: CellView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var icon: UIImageView!
}

class StaticSectionCell: SectionController {
    public override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        guard let section = loadDefaultHeaderForTableView(tableView: tableView, viewForHeaderInSection: section) as? StaticSectionCellView else {
            return UIView()
        }
        section.backgroundColor = .white
        section.setTitle("Custom header view code")
        return section
    }
}

class StaticSectionCellView: SectionView {
    private lazy var titleLabel = UILabel()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
