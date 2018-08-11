//
//  TableViewManager.swift
//  TableViewManager
//
//  Created by Julio Fernandes on 18/02/18.
//

import UIKit

@objc public protocol TableViewManagerDelegate: NSObjectProtocol {
    @objc optional func tableViewManager(table: SelfTableViewManager, didSelectRow row: CellController, atSection section: SectionController?)
    @objc optional func tableViewManager(table: SelfTableViewManager, didSelectRowAtIndexPath indexPath: IndexPath)
    @objc optional func tableViewManager(table: SelfTableViewManager, scrollView: UIScrollView, didChangeScrollOffset newOffset: CGPoint)
    @objc optional func tableViewManager(table: SelfTableViewManager, scrollView: UIScrollView, didDraggedToPosition newOffset: CGPoint)
    @objc optional func tableViewManager(table: SelfTableViewManager, willBeginDragging offset: CGPoint)
}

public enum TableViewManagerMode: Int {
    case single
    case multiple
}

public enum TableViewManagerType: Int {
    case staticDimension
    case automaticDimension
}

open class SelfTableViewManager: UITableView {
    
    deinit {
        managerDelegate = nil
        print(description)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.bootstrap()
        delegate = self
        dataSource = self
    }
    
    /// Define
    func bootstrap() {
        if self.tableViewManagerType() == .automaticDimension {
            estimatedRowHeight = 44
            rowHeight = UITableViewAutomaticDimension
        }
    }
    
    /// define type
    func tableViewManagerType() -> TableViewManagerType {
        return .automaticDimension
    }
    
    /// MARK: TableViewManagerDelegate protocol
    private weak var managerDelegate: TableViewManagerDelegate?
    @IBOutlet public weak var managerProtocol: AnyObject? {
        get { return managerDelegate }
        set { managerDelegate = newValue as? TableViewManagerDelegate }
    }
    
    /// MARK: Mode
    private var mode: TableViewManagerMode = .single
    public func getCollectionViewMode() -> TableViewManagerMode {
        return mode
    }
    
    /// MARK: Input data
    public private(set) var rows = [AnyObject]()
    public func setRows(_ rows: [AnyObject]) {
        self.rows = rows
        self.mode = .single
        self.reloadData()
    }
    
    
    public var setSectionsAndRows = [AnyObject]() {
        willSet { setSectionsAndRows(sequence: newValue) }
    }
    
    public private(set) var sections = [AnyObject]()
    private var sectionsAndRows = [AnyObject]()
    private func setSectionsAndRows(sequence: [AnyObject]) {
        
        guard hasSection(sequence: sequence) else {
            rows = sequence
            return
        }
        
        var _rows = [AnyObject]()
        var _newSections = [AnyObject]()
        var _cleanSecAndRows = [AnyObject]()
        var currentSection: SectionController?
        
        for (index, data) in sequence.enumerated() {
            
            if let item = data as? CellController { _rows.append(item) }
            
            if let item = data as? SectionController {
                if currentSection != nil {
                    currentSection?.rows = _rows as [AnyObject]?
                    _cleanSecAndRows.append(contentsOf: _rows)
                    _newSections.append(currentSection!)
                }
                
                _rows.removeAll()
                _rows = [AnyObject]()
                currentSection = item
                _cleanSecAndRows.append(currentSection!)
            }
            
            if index + 1 == sequence.count {
                if currentSection != nil {
                    currentSection?.rows = _rows as [AnyObject]?
                    _cleanSecAndRows.append(contentsOf: _rows)
                    _newSections.append(currentSection!)
                }
                
                if let item = data as? SectionController {
                    _rows.removeAll()
                    _rows = [AnyObject]()
                    currentSection = item
                    _cleanSecAndRows.append(currentSection!)
                }
            }
        }
        
        sectionsAndRows.removeAll(keepingCapacity: false)
        sectionsAndRows = _cleanSecAndRows
        
        sections.removeAll(keepingCapacity: false)
        sections = _newSections
        
        mode = .multiple
        self.reloadData()
    }
    
    /// Validamos se o array contains objeto do tipo SectionController
    ///
    /// - Parameter sequence: lista de collectionView
    /// - Returns: returna se achou ou não a sessão
    private func hasSection(sequence: [AnyObject]) -> Bool {
        return sequence.contains(where: { $0 is SectionController })
    }
    
    /// Busca a cell controller e retorna o indexPath
    ///
    /// - Parameter cell: cell controller
    /// - Returns: return o indexPath
    private func searchCellControllerForMultipleMode(cell: CellController) -> IndexPath? {
        for (i, aSection) in sections.enumerated() {
            if let section = aSection as? SectionController, let rows = section.rows {
                for (j, aCell) in rows.enumerated() {
                    if let aCell = aCell as? CellController {
                        if aCell == cell {
                            return IndexPath(row: j, section: i)
                        }
                    }
                }
            }
        }
        return nil
    }
    
    /// Busca a cell controller e retorna o indexPath
    ///
    /// - Parameter cell: cell controller
    /// - Returns: return o indexPath
    private func searchCellControllerForSingleMode(cell: CellController) -> IndexPath? {
        for (index, aCell) in rows.enumerated() {
            if let aCell = aCell as? CellController {
                if(aCell == cell) {
                    return IndexPath(row: index, section: 0)
                }
            }
        }
        return nil
    }
    
    /// Retorna a cellController
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: return a cell controller
    public func findControllerAtIndexPath(indexPath: IndexPath) -> CellController? {
        var controller: CellController?
        if mode == .single {
            if rows.count > indexPath.row {
                controller = rows[indexPath.row] as? CellController
            }
        } else {
            if let section = sections[indexPath.section] as? SectionController, let rows = section.rows {
                controller = rows[indexPath.row] as? CellController
            }
        }
        
        return controller
    }
    
    /// Retorna o indexPath de uma cell controller
    ///
    /// - Parameter cell: cell controller
    /// - Returns: indexPath
    public func indexPathForCellController(cell: CellController) -> IndexPath? {
        return mode == .multiple ?
            searchCellControllerForMultipleMode(cell: cell) :
            searchCellControllerForSingleMode(cell: cell)
    }
    
    /// Marca a cell como selecionada
    ///
    /// - Parameter cell: cell controller
    public func markCellAsSelected(cell: CellController) {
        if let path = indexPathForCellController(cell: cell) as IndexPath? {
            selectRow(at: path, animated: false, scrollPosition: .none)
        }
    }
}

// MARK: - Rows manipulation
extension SelfTableViewManager {

    public func removeAt(position: Int, rowsCount count: Int, animation: UITableViewRowAnimation) {
        
        var paths = [IndexPath]()
        var discardRows = [AnyObject]()
        
        let allRows = NSMutableArray(array: rows)
        
        for (index, cellController) in rows.enumerated() {
            if index >= position && index <= (position + count) {
                discardRows.append(cellController)
                let path: IndexPath = indexPathForCellController(cell: cellController as! CellController)!
                paths.append(path)
            }
        }
        
        allRows.removeObjects(in: discardRows)
        
        if #available(iOS 11.0, *) {
            performBatchUpdatesRemoveRows(paths: paths, allRows: allRows, animation: animation)
        } else {
            performBeginUpdatesRemoveRows(paths: paths, allRows: allRows, animation: animation)
        }
    }
    
    public func insertRowsOnTop(rows: [AnyObject], animation: UITableViewRowAnimation) {
        insertRows(rows: rows, at: 0, animation: animation)
    }
    
    public func insertRows(rows: [AnyObject], at position: Int, animation: UITableViewRowAnimation) {
        
        for i in (0..<rows.count).reversed() {
            if let cell = rows[i] as? CellController {
                self.rows.insert(cell, at: position)
            }
        }
        
        var paths = [IndexPath]()
        for i in 0..<rows.count {
            if let cell = rows[i] as? CellController, let path = indexPathForCellController(cell: cell) {
                paths.append(path)
            }
        }
        
        if #available(iOS 11.0, *) {
            performBatchUpdatesInsertRows(paths: paths, animation: animation)
        } else {
            performBeginUpdatesInsertRows(paths: paths, animation: animation)
        }
        
    }
    
}

extension SelfTableViewManager {
    @available(iOS 11.0, *)
    internal func performBatchUpdatesRemoveRows(paths: [IndexPath], allRows: NSArray, animation: UITableViewRowAnimation) {
        performBatchUpdates({
            self.rows.removeAll()
            self.rows = allRows as [AnyObject]
            self.deleteRows(at: paths, with: animation)
        })
    }
    
    internal func performBeginUpdatesRemoveRows(paths: [IndexPath], allRows: NSArray, animation: UITableViewRowAnimation) {
        beginUpdates()
        self.rows.removeAll()
        self.rows = allRows as [AnyObject]
        self.deleteRows(at: paths, with: animation)
        endUpdates()
    }
}

// MARK: - Insert Rows
extension SelfTableViewManager {
    @available(iOS 11.0, *)
    internal func performBatchUpdatesInsertRows(paths: [IndexPath], animation: UITableViewRowAnimation) {
        performBatchUpdates({ self.insertRows(at: paths, with: animation) })
    }
    
    internal func performBeginUpdatesInsertRows(paths: [IndexPath], animation: UITableViewRowAnimation) {
        beginUpdates()
        self.insertRows(at: paths, with: animation)
        endUpdates()
    }
}

// MARK: - UITableViewDataSource Methods
extension SelfTableViewManager: UITableViewDataSource {
    
    override open func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        let cell = super.dequeueReusableCell(withIdentifier: identifier) as? CellView
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if mode == .single {
            return 1
        } else {
            return sections.count
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == .single {
            return rows.count
        } else {
            if sections.count == 0 { return 0 }
            if let controller = sections[section] as? SectionController { return controller.rows!.count }
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return UITableViewCell() }
        controller.tableview = tableView
        return controller.tableView(tableView: tableView, cellForRowAtIndexPath: indexPath)
    }
    
}

extension SelfTableViewManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections.count == 0 { return 0 }
        let controller = sections[section] as! SectionController
        return controller.tableView(tableView: tableView, heightForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if sections.count == 0 { return nil }
        let controller = sections[section] as! SectionController
        controller.tableView = tableView
        return controller.tableView(tableView: tableView, viewForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return }
        controller.tableView(tableView: tableView, didSelectThisCellAtIndexPath: indexPath)
        
        if let delegate = managerDelegate {
            if delegate.responds(to: #selector(TableViewManagerDelegate.tableViewManager(table:didSelectRow:atSection:))) {
                delegate.tableViewManager!(table: self, didSelectRow: controller, atSection: nil)
            }
        
            if delegate.responds(to: #selector(TableViewManagerDelegate.tableViewManager(table:didSelectRowAtIndexPath:))) {
                delegate.tableViewManager!(table: self, didSelectRowAtIndexPath: indexPath)
            }
        }
    }
    
}

// MARK: - ScrollView manipulation
extension SelfTableViewManager {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let delegate = managerDelegate {
            if delegate.responds(to: #selector(TableViewManagerDelegate.tableViewManager(table:scrollView:didChangeScrollOffset:))) {
                delegate.tableViewManager!(table: self, scrollView: scrollView, didChangeScrollOffset: self.contentOffset)
            }
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let delegate = managerDelegate, decelerate {
            if delegate.responds(to: #selector(TableViewManagerDelegate.tableViewManager(table:scrollView:didDraggedToPosition:))) {
                delegate.tableViewManager!(table: self, scrollView: scrollView, didDraggedToPosition: scrollView.contentOffset)
            }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let delegate = managerDelegate {
            if delegate.responds(to: #selector(TableViewManagerDelegate.tableViewManager(table:willBeginDragging:))) {
                delegate.tableViewManager!(table: self, willBeginDragging: scrollView.contentOffset)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let delegate = managerDelegate {
            if delegate.responds(to: #selector(TableViewManagerDelegate.tableViewManager(table:scrollView:didDraggedToPosition:))) {
                delegate.tableViewManager!(table: self, scrollView: scrollView, didDraggedToPosition: scrollView.contentOffset)
            }
        }
    }
}

//MARK: CellController
@objc(CellController)
open class CellController: NSObject {
    
    @IBOutlet public weak var controllerCell: CellView!
    
    fileprivate var tableview: UITableView?
    fileprivate var tag: Int?
    fileprivate var identifier: String?
    fileprivate var currentObject: AnyObject?
    
    deinit{
        tableview = nil
        controllerCell = nil
    }
    
    public override init() {
        super.init()
    }
    
    open func reloadMe(animation: UITableViewRowAnimation) {
        if let tableview = tableview as? SelfTableViewManager, let thisIP = tableview.indexPathForCellController(cell: self) as IndexPath? {
            tableview.reloadRows(at: [thisIP], with: animation)
        }
    }
    
    open func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return loadDefaultCellForTable(tableView: tableView, atIndexPath: indexPath) as! CellView
    }
    
    open func loadDefaultCellForTable(tableView: UITableView, atIndexPath indexPath: IndexPath) -> AnyObject {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier()) as? CellView
        
        if cell == nil {
            _ = SelfTableViewManagerCache.shared().loadNib(path: reuseIdentifier(), owner: self)
            cell = controllerCell;
            controllerCell = nil
        }
        
        cell!.controller = self
        
        return cell!
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @objc open func tableView(tableView: UITableView, didSelectThisCellAtIndexPath indexPath: IndexPath) {}
    
    fileprivate func reuseIdentifier() -> String { return NSStringFromClass(object_getClass(self)!) }
    
}

open class CellView: UITableViewCell {
    
    var loadedKey: String?
    
    @IBOutlet weak var controller: CellController!
    @IBOutlet weak var backgroundCell: UIView!
    
    deinit{
        controller = nil
        loadedKey = nil
    }
}

//MARK: Section
@objc(SectionController)
open class SectionController: NSObject {
    
    @IBOutlet weak var controllerSection: SectionView!
    
    var rows: [AnyObject]?
    var tableView: UITableView?
    
    deinit{
        rows = nil
        tableView = nil
        controllerSection = nil
    }
    
    open func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return ""
    }
    
    open func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        return loadDefaultHeaderForTableView(tableView: tableView, viewForHeaderInSection: section)
    }
    
    fileprivate func customNibName() -> String { return NSStringFromClass(object_getClass(self)!) }
    
    open func loadDefaultHeaderForTableView(tableView: UITableView, viewForHeaderInSection section: Int) -> SectionView {
        let xibName = customNibName()
        _ = SelfTableViewManagerCache.shared().loadNib(path: xibName, owner: self)
        let sectionView = controllerSection!
        sectionView.controller = self
        
        return sectionView
    }
    
    func reloadMe() {
        tableView?.reloadData()
    }
}

open class SectionView: UIView {
    
    @IBOutlet weak var controller: SectionController!
    
    deinit{ controller = nil }
}
