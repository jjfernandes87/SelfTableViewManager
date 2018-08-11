//
//  SelfTableViewManagerStatic.swift
//  Pods-SelfTableViewManager_Example
//
//  Created by Julio Fernandes on 11/08/18.
//

import UIKit

open class SelfTableViewManagerStatic: SelfTableViewManager {
    
    override func tableViewManagerType() -> TableViewManagerType {
        return .staticDimension
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return 44 }
        return controller.tableView(tableView, heightForRowAt: indexPath)
    }
    
}
