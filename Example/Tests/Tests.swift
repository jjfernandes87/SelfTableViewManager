import XCTest
import SelfTableViewManager

class Tests: XCTestCase {
    
    var systemUnderTest: TestViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "TestViewController") as? TestViewController
        _ = systemUnderTest.view
    }
    
    override func tearDown() {
        super.tearDown()
        systemUnderTest = nil
    }
    
    func testCanInstantiateViewController() {
        XCTAssertNotNil(systemUnderTest)
    }
    
    func testTableViewManagerNotNill() {
        XCTAssertNotNil(systemUnderTest.tableView)
    }
    
    func testShouldSetTableViewDataSource() {
        XCTAssertNotNil(systemUnderTest.tableView.dataSource)
    }
    
    func testShouldSetTableViewDelegate() {
        XCTAssertNotNil(systemUnderTest.tableView.delegate)
    }
    
    func testTableViewManagerMode() {
        let table = systemUnderTest.tableView!
        XCTAssertEqual(table.getCollectionViewMode(), TableViewManagerMode.single)
    }
    
    func testTableViewManagerItemsCount() {
        let table = systemUnderTest.tableView!
        let items = [CellController(), CellController()]
        table.setRows(items)
        XCTAssertEqual(table.rows.count, items.count)
    }
    
    func testTableViewManagerModeMultiple() {
        let table = systemUnderTest.tableView!
        let items = [SectionController(), CellController(), CellController()]
        table.setSectionsAndRows = items
        XCTAssertEqual(table.getCollectionViewMode(), TableViewManagerMode.multiple)
    }
    
    func testSetSectionAndRowsWithoutSection() {
        let table = systemUnderTest.tableView!
        let items = [CellController(), CellController()]
        table.setSectionsAndRows = items
        XCTAssertEqual(table.getCollectionViewMode(), TableViewManagerMode.single)
    }
    
    func testTableViewManagerSectionCount() {
        let table = systemUnderTest.tableView!
        let items = [SectionController(), CellController(), SectionController()]
        table.setSectionsAndRows = items
        XCTAssertEqual(table.sections.count, 2)
    }
    
    func testIndexPathForCellTableSimpleMode() {
        let table = systemUnderTest.tableView!
        let items = [CellController(), CellController(), CellController()]
        table.setRows(items)
        let indexPath = table.indexPathForCellController(cell: items[1])
        XCTAssertEqual(indexPath, IndexPath(item: 1, section: 0))
    }
    
    func testIndexPathForCellTableMultipleMode() {
        let table = systemUnderTest.tableView!
        let cell = CellController()
        let items = [SectionController(), CellController(), SectionController(), cell, CellController()]
        table.setSectionsAndRows = items
        let indexPath = table.indexPathForCellController(cell: cell)
        XCTAssertEqual(indexPath, IndexPath(item: 0, section: 1))
    }
    
    func testIndexPathForNilCellTableSimpleMode() {
        let table = systemUnderTest.tableView!
        let items = [CellController(), CellController(), CellController()]
        table.setRows(items)
        let indexPath = table.indexPathForCellController(cell: CellController())
        XCTAssertNil(indexPath)
    }
    
    func testIndexPathForNilCellControllerMultipleMode() {
        let table = systemUnderTest.tableView!
        let items = [SectionController(), CellController(), SectionController(), CellController(), CellController()]
        table.setSectionsAndRows = items
        let indexPath = table.indexPathForCellController(cell: CellController())
        XCTAssertNil(indexPath)
    }
    
    func testFindTableAtIndexPathForSimpleMode() {
        let cell = CellController()
        let index = IndexPath(item: 1, section: 0)
        let table = systemUnderTest.tableView!
        let items = [CellController(), cell, CellController()]
        table.setRows(items)
        let findCell = table.findControllerAtIndexPath(indexPath: index)
        XCTAssertEqual(cell, findCell)
    }
    
    func testFindControllerAtIndexPathForMultipleMode() {
        let cell = CellController()
        let index = IndexPath(item: 0, section: 1)
        let table = systemUnderTest.tableView!
        let items = [SectionController(), CellController(), SectionController(), cell, CellController()]
        table.setSectionsAndRows = items
        let findCell = table.findControllerAtIndexPath(indexPath: index)
        XCTAssertEqual(cell, findCell)
    }

    func testScrollViewWillBeginDragging() {
        let mock = ScrollTableViewMock()
        let table = systemUnderTest.tableView!
        let items = [CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController()
        ]
        table.setRows(items)
        table.managerProtocol = mock
        table.scrollViewWillBeginDragging(table)
        XCTAssertEqual(mock.scrollViewWillBeginDragging, true)
    }

    func testScrollViewDidEndDecelerating() {
        let mock = ScrollTableViewMock()
        let table = systemUnderTest.tableView!
        let items = [CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController()
        ]
        table.setRows(items)
        table.managerProtocol = mock
        table.scrollViewDidEndDecelerating(table)
        XCTAssertEqual(mock.scrollViewDidEndDecelerating, true)
    }

    func testDidEndDisplaying() {
        let mock = ScrollTableViewMock()
        let table = systemUnderTest.tableView!
        let items = [CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController(),
                     CellController()
        ]
        table.setRows(items)
        table.managerProtocol = mock
        table.tableView(table, didEndDisplaying: UITableViewCell(), forRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(mock.didEndDisplaying, true)
    }

}

/// Micks
class ScrollTableViewMock: NSObject, TableViewManagerDelegate {

    var scrollViewWillBeginDragging = false
    var scrollViewDidEndDecelerating = false
    var didEndDisplaying = false

    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewWillBeginDragging scrollView: UIScrollView) {
        self.scrollViewWillBeginDragging = true
    }

    func tableViewManager(_ tableView: SelfTableViewManager, scrollViewDidEndDecelerating scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating = true
    }

    func tableViewManager(_ table: SelfTableViewManager, didEndDisplaying cell: CellController) {
        self.didEndDisplaying = true
    }
}
