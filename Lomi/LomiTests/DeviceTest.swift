//
//  DeviceTest.swift
//  LomiTests
//
//  Created by Takayuki Yamaguchi on 2022-01-24.
//

import XCTest
@testable import Lomi

class DeviceTest: XCTestCase {
    
    private(set) var device: Device!
    private let validSerialNumber: String = "\(AppDefault.SERIAL_NUMBER_PREFIX)0121123456"
    private let validNickname: String = "Nickname"
    
    override func setUp() {
        super.setUp()
        device = Device()
    }
    override func tearDown() {
        device = nil
        super.tearDown()
    }
    
    
    // MARK: - Common
    
    func testIsAllValid() {
        device.serialNumber = validSerialNumber
        device.nickname = validNickname
        XCTAssert(device.isAllValid())
    }
    
    
    // MARK: - Serial number
    
    // All
    func testSerialNumIsValid() {
        XCTAssert(device.isValidSerialNum(validSerialNumber))
    }
    
    func testSerialNumInvalidSuffix() {
        XCTAssertFalse(device.isValidSerialNum("\(AppDefault.SERIAL_NUMBER_PREFIX)0124000000"))
    }
    
    func testSerialNumInvalidLength() {
        XCTAssertFalse(device.isValidSerialNum(validSerialNumber+"0"))
    }
    
    // Inputs
    func testSerialNumInputIsValid() {
        XCTAssert(device.isValidSerialNumInput("\(AppDefault.SERIAL_NUMBER_PREFIX)123"))
    }
    
    func testSerialNumInputInvalidPrefix() {
        XCTAssertFalse(device.isValidSerialNumInput("INVALID"))
    }
    
    func testSerialNumInputNotDigits() {
        XCTAssertFalse(device.isValidSerialNumInput("\(AppDefault.SERIAL_NUMBER_PREFIX)abc"))
    }
    
    func testSerialNumInputTooLong() {
        let str = String(repeating: "1", count: AppDefault.SERIAL_NUMBER_DIGITS_LENGTH+1)
        XCTAssertFalse(device.isValidSerialNumInput("\(AppDefault.SERIAL_NUMBER_PREFIX)\(str)"))
    }
    
    // Suffix
    func testSerialNumSuffixIsValid() {
        XCTAssert(device.hasValidSerialNumSuffix(validSerialNumber))
    }
    
    func testSerialNumSuffixInvalidMonth() {
        XCTAssertFalse(device.hasValidSerialNumSuffix("1322000000"))
    }

    func testSerialNumSuffixInvalidYear() {
        XCTAssertFalse(device.hasValidSerialNumSuffix("1223000000"))
    }
    
    
    // Length
    func testSerialNumValidLength() {
        XCTAssert(device.isValidSerialNumLength(validSerialNumber))
    }
    
    func testSerialNumTooShort() {
        let short = String(validSerialNumber.dropLast())
        XCTAssertFalse(device.isValidSerialNumLength(short))
    }
    
    func testSerialNumTooLong() {
        let long = validSerialNumber+"0"
        XCTAssertFalse(device.isValidSerialNumLength(long))
    }
    
    
    // MARK: - Nickname
    
    func testNicknameIsEmpty() {
        device.serialNumber = validSerialNumber
        device.nickname = ""
        XCTAssertFalse(device.isAllValid())
    }
    
    func testNicknameTooShort() {
        device.serialNumber = validSerialNumber
        device.nickname = String(repeating: "a", count: max(AppDefault.NAME_RANGE.lowerBound-1, 0))
        XCTAssertFalse(device.isAllValid())
    }
    
    func testNicknameTooLong() {
        device.serialNumber = validSerialNumber
        device.nickname = String(repeating: "a", count: AppDefault.NAME_RANGE.upperBound+1)
        XCTAssertFalse(device.isAllValid())
    }

}
