//
//  WeldLearnTests.swift
//  WeldLearnTests
//
//  Created by JWSScott777 on 1/15/21.
//
import CoreData
import XCTest
@testable import WeldLearn

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
