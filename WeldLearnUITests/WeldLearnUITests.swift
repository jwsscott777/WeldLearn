//
//  WeldLearnUITests.swift
//  WeldLearnUITests
//
//  Created by JWSScott777 on 2/18/21.
//

import XCTest

class WeldLearnUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppHas4Tabs() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in app")
    }

    func testOpenTabAddsProjects() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "Should be no list rows")

        for tapCount in 1...5 {
            app.buttons["add"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "Should be \(tapCount) list rows")
        }
    }

    func testAddingItemInsertsRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "Should be no list rows")

        app.buttons["add"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "Should be 1 list rows")

        app.buttons["Add New Item"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "Should be 2 list rows")
    }

    func testingEditingProjectUpdates() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "Should be no list rows")

        app.buttons["add"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "Should be 1 list rows")

        app.buttons["NEW PROJECT"].tap()
        app.textFields["Project name"].tap()

        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.buttons["NEW PROJECT 2"].exists, "This should be here")
    }
//    func testingEditingItemUpdates() {
//        testAddingItemInsertsRows()
//
//        app.buttons["New Item"].tap()
//        app.textFields["Item name"].tap()
//
//        app.keys["space"].tap()
//        app.keys["more"].tap()
//        app.keys["2"].tap()
//        app.buttons["Return"].tap()
//
//        app.buttons["Open Projects"].tap()
//        XCTAssertTrue(app.buttons["NEW ITEM 2"].exists, "This should be here")
//    }
    func testAllAwardsShowLockedAlert() {
        app.buttons["Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()

            XCTAssertTrue(app.alerts["Locked"].exists, "Should be awards")
            app.buttons["OK"].tap()
        }
    }
}
