//
//  NameLomiV2ViewControllerTests.swift
//  LomiTests
//
//  Created by Takayuki Yamaguchi on 2022-08-04.
//

import XCTest
@testable import Lomi

final class NameLomiV2ViewControllerTests: XCTestCase {
    
    private var viewController: NameLomiV2Controller!
    
    override func setUp() {
        super.setUp()
        viewController = NameLomiV2Controller()
    }
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    /// Check if we can combine two generated name properly
    func testGetRandomName() {
        let keysLeft = ["left"]
        let keysRight = ["right"]
        
        viewController.setupSources(sourceKeysLeft: keysLeft, sourceKeysRight: keysRight)
        let name = viewController.getRandomName()
        SystemLogger.log.debug(messages: name)
        
        XCTAssertEqual(name, "Left Right")
    }
    
    /// Check if default values are provided if we can't generate keys
    func testGetRandomNameDefault() {
        let keysLeft: [String] = []
        let keysRight: [String] = []
        let keyLeftDefault = "Left Default"
        let keyRightDefault = "Right Default"

        viewController.setupSources(sourceKeysLeft: keysLeft, sourceKeysRight: keysRight, sourceKeyLeftDefault: keyLeftDefault, sourceKeyRightDefault: keyRightDefault)
        let name = viewController.getRandomName()
        SystemLogger.log.debug(messages: name)

        XCTAssertEqual(name, "\(keyLeftDefault) \(keyRightDefault)")
    }
    
    /// Check if the generated word also exists in the original source.
    func testGetRandomKey() {
        let source = Range(0...10000).map { i in
            return "word\(i)"
        }
        let key = viewController.getRandomKey(source: source)
        let gKey = key ?? "key is nil"
        SystemLogger.log.debug(messages: gKey)
        XCTAssert(source.contains { $0 == gKey.lowercased() })
    }
    
    /// Check if the generator returns nil if source is emtpy
    func testGetRandomKeyNoSource() {
        let source: [String] = []
        let key = viewController.getRandomKey(source: source)
        XCTAssertNil(key)
    }
}
