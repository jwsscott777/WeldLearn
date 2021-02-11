//
//  PerformanceTests.swift
//  WeldLearnTests
//
//  Created by JWSScott777 on 2/10/21.
//

import XCTest
@testable import WeldLearn

class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() throws {
        // Create alot of test data
        for _ in 1...100 {
        try dataController.createSampleData()
        }

        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500,
                       "This test is for the amount of awards currently, change if new awards are added")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }

}
