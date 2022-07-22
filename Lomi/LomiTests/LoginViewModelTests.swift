//
//  LoginViewModelTests.swift
//  LomiTests
//
//  Created by Takayuki Yamaguchi on 2022-06-09.
//

import XCTest
@testable import Lomi

// FIXME: We will create a viewModel for login and replace it.
class LoginViewModelTests: XCTestCase {

    private var loginViewModel: LogInViewController!
    private let NAME_RANGE = AppDefault.NAME_RANGE
    private let PASSWORD_RANGE = AppDefault.PASSWORD_RANGE
    
    override func setUp() {
        super.setUp()
        loginViewModel = LogInViewController()
    }
    override func tearDown() {
        loginViewModel = nil
        super.tearDown()
    }
    
    
    //MARK: - IsAllValid
    func testIsAllValid() {
        loginViewModel.email = "valid_email@address.com"
        loginViewModel.password = "Ab1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-3)
        XCTAssertTrue(loginViewModel.isAllValid())
    }
    
    func testIsAllValidFailure() {
        loginViewModel.email = "invalid_email"
        loginViewModel.password = "Ab1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-3)
        XCTAssertFalse(loginViewModel.isAllValid())
    }

}
