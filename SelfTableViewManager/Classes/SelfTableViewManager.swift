//
//  TableViewManager.swift
//  TableViewManager
//
//  Created by Julio Fernandes on 18/02/18.
//

import UIKit

/// TableViewManagerMode
public enum TableViewManagerMode: Int {
    case single
    case multiple
}

/// TableViewManagerType
public enum TableViewManagerType: Int {
    case staticDimension
    case automaticDimension
}

/// SelfTableViewManager class
open class SelfTableViewManager: UITableView {
    
    deinit {
        managerDelegate = nil
        print(description)
    }

    /// Init
    public init() {
        super.init(frame: .zero, style: .plain)
        self.bootstrap()
    }

    /// Init with frame
    /// - Parameter frame: CGRect
    public init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        self.bootstrap()
    }

    /// Init with coder
    /// - Parameter aDecoder: aDecoder
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.bootstrap()
    }
    
    /// bootstrap framework with automatic dimension
    func bootstrap() {
        if self.tableViewManagerType() == .automaticDimension {
            estimatedRowHeight = 44
            rowHeight = UITableView.automaticDimension
        }

        delegate = self
        dataSource = self
    }
    
    /// define tableview type
    func tableViewManagerType() -> TableViewManagerType {
        return .automaticDimension
    }
    
    /// MARK: TableViewManagerDelegate protocol
    private weak var managerDelegate: TableViewManagerDelegate?
    @IBOutlet public weak var managerProtocol: AnyObject? {
        get { return managerDelegate }
        set { managerDelegate = newValue as? TableViewManagerDelegate }
    }

    /// TableViewManagerMode
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

    /// setSectionsAndRows
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
    
    /// Validate if array contains obj type of SectionController
    ///
    /// - Parameter sequence: rows
    /// - Returns: true or false
    private func hasSection(sequence: [AnyObject]) -> Bool {
        return sequence.contains(where: { $0 is SectionController })
    }
    
    /// Search for cellController and return its index
    ///
    /// - Parameter cell: cellController
    /// - Returns: indexPath
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
    
    /// Search for cellController and return its index
    ///
    /// - Parameter cell: cellController
    /// - Returns: indexPath
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

    /// Search for cellController and return its index
    ///
    /// - Parameter cell: cell controller
    /// - Returns: indexPath
    public func indexPathForCellController(cell: CellController) -> IndexPath? {
        return mode == .multiple ?
            searchCellControllerForMultipleMode(cell: cell) :
            searchCellControllerForSingleMode(cell: cell)
    }
    
    /// Access the index and return to cellController
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: cellController
    public func findControllerAtIndexPath(indexPath: IndexPath) -> CellController? {
        var controller: CellController?
        if mode == .single {
            if rows.count > indexPath.row {
                controller = rows[indexPath.row] as? CellController
            }
        } else {
            if sections.count > indexPath.section, let section = sections[indexPath.section] as? SectionController, let rows = section.rows, rows.count > indexPath.row {
                controller = rows[indexPath.row] as? CellController
            }
        }
        
        return controller
    }
    
    /// Change cellController for selected state
    ///
    /// - Parameter cell: cellController
    public func markCellAsSelected(cell: CellController) {
        if let path = indexPathForCellController(cell: cell) as IndexPath? {
            selectRow(at: path, animated: false, scrollPosition: .none)
        }
    }
}

// MARK: - Rows manipulation
extension SelfTableViewManager {

    /// Remove rows
    /// - Parameter position: start index
    /// - Parameter count: number of cells
    /// - Parameter animation: animation type
    public func removeAt(position: Int, rowsCount count: Int, animation: UITableView.RowAnimation) {
        
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
        
        rows = allRows as [AnyObject]
        deleteRows(at: paths, with: animation)
    }

    /// Insert cells on top
    /// - Parameter rows: cells list
    /// - Parameter animation: animation type
    public func insertRowsOnTop(rows: [AnyObject], animation: UITableView.RowAnimation) {
        insertRows(rows: rows, at: 0, animation: animation)
    }

    /// Insert cells
    /// - Parameter rows: cells list
    /// - Parameter position: start index
    /// - Parameter animation: animation type
    public func insertRows(rows: [AnyObject], at position: Int, animation: UITableView.RowAnimation) {
        
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
        
        insertRows(at: paths, with: animation)
    }
}

// MARK: - UITableViewDataSource methods
extension SelfTableViewManager: UITableViewDataSource {
    
    override open func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        let cell = super.dequeueReusableCell(withIdentifier: identifier) as? CellView
        return cell
    }

    /// numberOfSections
    /// - Parameter tableView: tableView
    /// - Returns: Count
    public func numberOfSections(in tableView: UITableView) -> Int {
        if mode == .single {
            return 1
        } else {
            return sections.count
        }
    }

    /// numberOfRowsInSection
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: section
    /// - Returns: count
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == .single {
            return rows.count
        } else {
            if sections.count == 0 { return 0 }
            if let controller = sections[section] as? SectionController { return controller.rows!.count }
            return 0
        }
    }

    /// cellForRowAt
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    /// - Returns: UITableViewCell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return UITableViewCell() }
        controller.tableview = tableView
        return controller.tableView(tableView: tableView, cellForRowAtIndexPath: indexPath)
    }

    /// editActionsForRowAt
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    /// - Returns: [UITableViewRowAction]
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return nil }
        controller.tableview = tableView
        return controller.tableView(tableView: tableView, editActionsForRowAt: indexPath)
    }

    /// canEditRowAt
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    /// - Returns: Bool
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return false }
        controller.tableview = tableView
        return controller.tableView(tableView: tableView, canEditRowAt: indexPath)
    }

    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return nil }
        controller.tableview = tableView
        return controller.tableView(tableView: tableView, leadingSwipeActionsConfigurationForRowAt: indexPath)
    }

    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return nil }
        controller.tableview = tableView
        return controller.tableView(tableView: tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }
}

// MARK: - UITableViewDelegate methods
extension SelfTableViewManager: UITableViewDelegate {

    /// heightForHeaderInSection
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: section
    /// - Returns: height
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections.count == 0 { return 0 }
        let controller = sections[section] as! SectionController
        return controller.tableView(tableView: tableView, heightForHeaderInSection: section)
    }

    /// viewForHeaderInSection
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: section
    /// - Returns: uiview
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if sections.count == 0 { return nil }
        let controller = sections[section] as! SectionController
        controller.tableView = tableView
        return controller.tableView(tableView: tableView, viewForHeaderInSection: section)
    }

    /// didSelectRowAt
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return }
        controller.tableView(tableView: tableView, didSelectThisCellAtIndexPath: indexPath)

        managerDelegate?.tableViewManager(self, didSelectRow: controller, atSection: nil)
        managerDelegate?.tableViewManager(self, didSelectRowAtIndexPath: indexPath)
    }

    /// willDisplay
    /// - Parameters:
    ///   - tableView: tableView
    ///   - cell: cell
    ///   - indexPath: indexPath
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return }
        managerDelegate?.tableViewManager(self, willDisplay: controller)
        managerDelegate?.tableViewManager(self, willDisplay: controller, indexPath: indexPath)
    }

    /// didEndDisplaying
    /// - Parameters:
    ///   - tableView: tableView
    ///   - cell: cell
    ///   - indexPath: indexPath
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let controller = findControllerAtIndexPath(indexPath: indexPath) else { return }
        managerDelegate?.tableViewManager(self, didEndDisplaying: controller)
        managerDelegate?.tableViewManager(self, didEndDisplaying: controller, indexPath: indexPath)
    }
}

// MARK: - ScrollView manipulation
extension SelfTableViewManager {

    /// scrollViewDidScroll
    /// - Parameter scrollView: scrollView
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        managerDelegate?.tableViewManager(self, scrollView: scrollView, didChangeScrollOffset: self.contentOffset)
        managerDelegate?.tableViewManager(self, scrollViewDidScroll: scrollView)
    }

    /// scrollViewDidEndDragging
    /// - Parameters:
    ///   - scrollView: scrollView
    ///   - decelerate: decelerate
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        managerDelegate?.tableViewManager(self, scrollView: scrollView, didDraggedToPosition: scrollView.contentOffset)
        managerDelegate?.tableViewManager(self, scrollViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }

    /// scrollViewWillBeginDragging
    /// - Parameter scrollView: scrollView
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        managerDelegate?.tableViewManager(self, willBeginDragging: scrollView.contentOffset)
        managerDelegate?.tableViewManager(self, scrollViewWillBeginDragging: scrollView)
    }

    /// scrollViewDidEndDecelerating
    /// - Parameter scrollView: scrollView 
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        managerDelegate?.tableViewManager(self, scrollView: scrollView, didDraggedToPosition: scrollView.contentOffset)
        managerDelegate?.tableViewManager(self, scrollViewDidEndDecelerating: scrollView)
    }
}

//MARK: CellController
open class CellController: NSObject {
    
    @IBOutlet public weak var controllerCell: CellView!

    /// internal control
    fileprivate var tableview: UITableView?
    fileprivate var identifier: String?
    fileprivate var persistentCell: Bool = false
    fileprivate var cachedCell: CellView?

    var tag: Int?
    var bundleURL: String?
    
    private var bundle: Bundle? {
        guard let bundleURL = bundleURL,
              let url = URL(string: bundleURL) else { return Bundle.main }
        return Bundle(url: url)
    }

    deinit {
        tableview = nil
        controllerCell = nil
        cachedCell = nil
    }

    public override init() {
        super.init()
    }

    public init(bundle: String? = nil) {
        self.bundleURL = bundle
        super.init()
    }

    public init(persistentCell: Bool = false) {
        self.persistentCell = persistentCell
        super.init()
    }
    
    open func reloadMe(animation: UITableView.RowAnimation) {
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
            let path = reuseIdentifier()
            let shouldLoadNib = bundle?.path(forResource: path, ofType: "nib") != nil
            if shouldLoadNib {
                _ = SelfTableViewManagerCache.shared().loadNib(path: path, owner: self, bundleURL: bundleURL)
                cell = controllerCell;
                controllerCell = nil
            } else {
                let identifier = getCellViewIdentifier(with: path)
                let instance = NSClassFromString(identifier) as? CellView.Type
                cell = instance?.init(style: .default, reuseIdentifier: reuseIdentifier())
            }
        }

        if persistentCell {
            cell?.beingPersisted = true
            cachedCell = cell
        }
        
        cell!.controller = self
        
        return cell!
    }

    open func tableView(tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }

    open func tableView(tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    @available(iOS 11.0, *)
    open func tableView(tableView: UITableView, trailingSwipeActionsConfigurationForRowAt: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }

    @available(iOS 11.0, *)
    open func tableView(tableView: UITableView, leadingSwipeActionsConfigurationForRowAt: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    @objc open func tableView(tableView: UITableView, didSelectThisCellAtIndexPath indexPath: IndexPath) {
        //EMPTY
    }
    
    fileprivate func reuseIdentifier() -> String {
        return String(describing: self.classForCoder)
    }
    
    private func getCellViewIdentifier(with path: String) -> String {
        if let bundleName = bundle?.infoDictionary?["CFBundleName"] as? String {
            return String(format: "\(bundleName).%@View", path)
        } else {
            return String(format: "%@View", path)
        }
    }
}

/// CellView
open class CellView: UITableViewCell {

    @IBOutlet weak var controller: CellController!
    @IBOutlet weak var backgroundCell: UIView!

    var loadedKey: String?
    var beingPersisted: Bool = false
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    deinit {
        controller = nil
        loadedKey = nil
    }
}

//MARK: Section
open class SectionController: NSObject {
    
    @IBOutlet weak var controllerSection: SectionView!
    
    var rows: [AnyObject]?
    var tableView: UITableView?
    var bundleURL: String?
    
    private var bundle: Bundle? {
        guard let bundleURL = bundleURL,
              let url = URL(string: bundleURL) else { return Bundle.main }
        return Bundle(url: url)
    }
    
    deinit {
        rows = nil
        tableView = nil
        controllerSection = nil
    }

    public init(bundle: String? = nil) {
        self.bundleURL = bundle
        super.init()
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
    
    fileprivate func customSectionName() -> String { return NSStringFromClass(object_getClass(self)!) }
    
    open func loadDefaultHeaderForTableView(tableView: UITableView, viewForHeaderInSection section: Int) -> SectionView {
        let sectionName = customSectionName()
        
        let sectionView: SectionView
        let isNibFileExists = bundle?.path(forResource: sectionName, ofType: "nib") != nil
        if isNibFileExists {
            _ = SelfTableViewManagerCache.shared().loadNib(path: sectionName, owner: self, bundleURL: bundleURL)
            sectionView = controllerSection!
        } else {
            let identifier = String(format: "%@View", sectionName)
            let instance = NSClassFromString(identifier) as? SectionView.Type
            sectionView = instance?.init(frame: .zero) ?? SectionView()
        }
        
        sectionView.controller = self
        
        return sectionView
    }
    
    func reloadMe() {
        tableView?.reloadData()
    }
}

/// SectionView
open class SectionView: UIView {
    
    @IBOutlet weak var controller: SectionController!
    
    deinit{ controller = nil }
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


