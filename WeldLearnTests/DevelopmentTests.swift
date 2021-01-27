//
//  DevelopmentTests.swift
//  WeldLearnTests
//
//  Created by JWSScott777 on 1/27/21.
//
import CoreData
import XCTest
@testable import WeldLearn

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should be 50 sample items")
    }

    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData()

        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "There should be 0 sample projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "There should be 0 sample items")
    }

    func testExampleProjectIsClosed() {
        let project = Project.example
        XCTAssertTrue(project.closed, "Example project should be closed")
    }

    func testExampleItemIsHighPriority() {
        let item = Item.example
        XCTAssertEqual(item.priority, 3, "There should be 3 types.")
    }
}
