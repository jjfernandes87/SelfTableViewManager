//
//  ViewCodeCell.swift
//  SelfTableViewManager_Example
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
        cell.setTitle("view code cell index: \(indexPath.row)")
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectThisCellAtIndexPath indexPath: IndexPath) {
        print("didSelectThisCellAtIndexPath")
    }
}

final class ViewCodeCellView: CellView {
    private lazy var titleLabel = UILabel()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
