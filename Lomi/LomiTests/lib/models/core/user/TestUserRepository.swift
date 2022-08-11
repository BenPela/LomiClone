//
//  TestUserRepository.swift
//  LomiTests
//
//  Created by Peter Harding on 2022-07-12.
//

import Foundation
import XCTest
@testable import Lomi

class TestUserRepository: XCTestCase {
    var mockStateContainer: MockStateContainer!
    var userRepository: UserRepository!
    var defaultStoredUser: StoredUser!

    override func setUp() {
        mockStateContainer = MockStateContainer(dataModel: "UserData")
        userRepository = UserRepository(stateContainer: mockStateContainer)
        defaultStoredUser = StoredUser(context: mockStateContainer.managedContext)
        defaultStoredUser.id = "123"
        defaultStoredUser.email = "test@apple.com"
        defaultStoredUser.firstName = "happy"
        defaultStoredUser.lastName = "tester"
        defaultStoredUser.lastUpdate = Date().timeIntervalSince1970
    }

    func testSaveUser() {
        guard let toSave = defaultStoredUser.toUser() else { return XCTFail() }
        let result = userRepository.saveUser(user: toSave)
        XCTAssertTrue(result)
        XCTAssertEqual(userRepository.cachedUser?.id, toSave.id)
    }

    func testGetUser() {
        _ = mockStateContainer.save(defaultStoredUser)
        let result = userRepository.getUser()
        XCTAssertEqual(result?.id, defaultStoredUser.id)
        XCTAssertEqual(result?.email, defaultStoredUser.email)
    }

    func testIsCachedValid() {
        guard let toSave = defaultStoredUser.toUser() else { return XCTFail() }
        _ = userRepository.saveUser(user: toSave) // make sure user is cached
        let result = userRepository.isCached()
        XCTAssertTrue(result)
    }

    func testIsCachedExpired() {
        let expected: StoredUser = defaultStoredUser
        expected.lastUpdate = Date().timeIntervalSince1970 + userRepository.cacheDuration + 1
        _ = mockStateContainer.save(expected)
        let result = userRepository.isCached()
        XCTAssertFalse(result)
    }

    override func tearDown() {
        _ = mockStateContainer.delete(defaultStoredUser)
    }

}
