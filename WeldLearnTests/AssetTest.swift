//
//  AssetTest.swift
//  WeldLearnTests
//
//  Created by JWSScott777 on 1/15/21.
//

import XCTest
@testable import WeldLearn

class AssetTest: XCTestCase {
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load from JSON")
    }

}
