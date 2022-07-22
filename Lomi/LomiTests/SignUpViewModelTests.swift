//
//  DeviceTest.swift
//  LomiTests
//
//  Created by Takayuki Yamaguchi on 2022-01-24.
//

import XCTest
@testable import Lomi

class SignUpViewModelTest: XCTestCase {
    
    private var signUpViewModel: SignUpViewModel!
    private let NAME_RANGE = AppDefault.NAME_RANGE
    private let PASSWORD_RANGE = AppDefault.PASSWORD_RANGE
    
    override func setUp() {
        super.setUp()
        signUpViewModel = SignUpViewModel()
    }
    override func tearDown() {
        signUpViewModel = nil
        super.tearDown()
    }
    
    //MARK: - IsAllValid
    
    func testIsAllValid() {
        signUpViewModel.firstName = String(repeating: "a", count: NAME_RANGE.upperBound)
        signUpViewModel.lastName = String(repeating: "a", count: NAME_RANGE.upperBound)
        signUpViewModel.email = "valid_email@address.com"
        signUpViewModel.password = "Ab1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-3)
        signUpViewModel.confirmationPassword = "Ab1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-3)
        XCTAssert(signUpViewModel.isAllValid())
    }
}

