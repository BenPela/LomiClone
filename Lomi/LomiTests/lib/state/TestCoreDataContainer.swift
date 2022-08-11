//
//  TestStateContainer.swift
//  LomiTests
//
//  Created by Peter Harding on 2022-07-12.
//

import Foundation
import XCTest
@testable import Lomi

class TestCoreDataContainer: XCTestCase {
    var stateContainer: CoreDataContainer!

    override func setUp() {
        // FIXME: this only seems to work if TestData has Lomi target membership
        // FIXME: can we make it LomiTests target membership only?
        stateContainer = CoreDataContainer(dataModel: "TestData")
    }

    // If a StoredUser does not exists, fetchFirst should return an object, but with nil properties
    func testEmptyUser() {
        let testData = stateContainer.fetchFirst(entityName: "StoredTestData") as! StoredTestData
        XCTAssertNotNil(testData)
        XCTAssertNil(testData.id)
    }

    func testSaveMissingProperty() {
        let testData = stateContainer.fetchFirst(entityName: "StoredTestData") as! StoredTestData
        testData.id = "test123"
        testData.name = "myname"
        // save should fail because required property "number" is not specified
        let result = stateContainer.save(testData)
        XCTAssertFalse(result)
        XCTAssertNil(testData.id)
        XCTAssertNil(testData.name)
    }

    func testSave() {
        let testData = stateContainer.fetchFirst(entityName: "StoredTestData") as! StoredTestData
        testData.id = "test123"
        testData.name = "myname"
        testData.number = 10
        let result = stateContainer.save(testData)
        XCTAssertTrue(result)
        XCTAssertEqual(testData.id, "test123")
        XCTAssertEqual(testData.name, "myname")
        XCTAssertEqual(testData.number, 10)
    }

    func testDelete() {
        let testData = stateContainer.fetchFirst(entityName: "StoredTestData") as! StoredTestData
        let result = stateContainer.delete(testData)
        XCTAssertTrue(result)
        XCTAssertNil(testData.id)
    }

    override func tearDown() {
        let testData = stateContainer.fetchFirst(entityName: "StoredTestData")
        _ = stateContainer.delete(testData)
    }

}
