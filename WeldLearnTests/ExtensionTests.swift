//
//  ExtensionTests.swift
//  WeldLearnTests
//
//  Created by JWSScott777 on 2/2/21.
//
import SwiftUI
import XCTest
@testable import WeldLearn

class ExtensionTests: XCTestCase {

    func testSequenceKeyPathSortingSelf() {
        let items = [1, 4, 3, 2, 5]
        let sortedItems = items.sorted(by: \.self)
        XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "The sorted numbers must be acending")
    }

    func testSequenceKeyPathSortingCustom() {
        struct Example: Equatable {
            let value: String
        }

        let example1 = Example(value: "a")
        let example2 = Example(value: "b")
        let example3 = Example(value: "c")
        let array = [example1, example2, example3]

        let sortedItems = array.sorted(by: \.value) {
            $0 > $1
        }

        XCTAssertEqual(sortedItems, [example3, example2, example1], "Reverse sorting ")
    }

    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array")
    }

    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        XCTAssertEqual(data, "This test is a simple string test.", "The string must match")
    }

    func testDecodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
        XCTAssertEqual(data.count, 3, "")
        XCTAssertEqual(data["One"], 1, "")
    }

    func testBindingOnChange() {
        // Given
        var onChangeFunctionRun = false

        func exampleFunctionToCall() {
            onChangeFunctionRun = true

            var storedValue = ""

            let binding = Binding(
                get: { storedValue },
            set: { storedValue = $0 }
            )

            let changeBinding = binding.onChange(exampleFunctionToCall)
            // When
            changeBinding.wrappedValue = "Test"

            // Then
            XCTAssertTrue(onChangeFunctionRun, "The onChange() must be run when the binding changes")
        }
    }
}
