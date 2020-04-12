//
//  SelfTableViewManagerProtocols.swift
//  SelfTableViewManager
//
//  Created by Julio Fernandes on 12/04/20.
//

import UIKit

/// Protocolos TableViewManagerDelegate
public protocol TableViewManagerDelegate: NSObjectProtocol {
    /// display manipulation
    func tableViewManager(_ table: SelfTableViewManager, willDisplay cell: CellController)
    func tableViewManager(_ table: SelfTableViewManager, willDisplay cell: CellController, indexPath: IndexPath)

    /// touch manipulation
    func tableViewManager(_ table: SelfTableViewManager, didSelectRow row: CellController, atSection section: SectionController?)
    func tableViewManager(_ table: SelfTableViewManager, didSelectRowAtIndexPath indexPath: IndexPath)

    /// scroll manipulation
    func tableViewManager(_ table: SelfTableViewManager, scrollView: UIScrollView, didChangeScrollOffset newOffset: CGPoint)
    func tableViewManager(_ table: SelfTableViewManager, scrollView: UIScrollView, didDraggedToPosition newOffset: CGPoint)
    func tableViewManager(_ table: SelfTableViewManager, willBeginDragging offset: CGPoint)

    /// scroll manipulation
    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewDidScroll scrollView: UIScrollView)
    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewWillBeginDragging scrollView: UIScrollView)
    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewDidEndDecelerating scrollView: UIScrollView)
}

extension TableViewManagerDelegate {
    /// display manipulation
    func tableViewManager(_ table: SelfTableViewManager, willDisplay cell: CellController) {}
    func tableViewManager(_ table: SelfTableViewManager, willDisplay cell: CellController, indexPath: IndexPath) {}

    /// touch manipulation
    func tableViewManager(_ table: SelfTableViewManager, didSelectRow row: CellController, atSection section: SectionController?) {}
    func tableViewManager(_ table: SelfTableViewManager, didSelectRowAtIndexPath indexPath: IndexPath) {}

    /// scroll manipulation
    func tableViewManager(_ table: SelfTableViewManager, scrollView: UIScrollView, didChangeScrollOffset newOffset: CGPoint) {}
    func tableViewManager(_ table: SelfTableViewManager, scrollView: UIScrollView, didDraggedToPosition newOffset: CGPoint) {}
    func tableViewManager(_ table: SelfTableViewManager, willBeginDragging offset: CGPoint) {}

    /// scroll manipulation
    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewDidScroll scrollView: UIScrollView) {}
    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewWillBeginDragging scrollView: UIScrollView) {}
    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewDidEndDecelerating scrollView: UIScrollView) {}
}
