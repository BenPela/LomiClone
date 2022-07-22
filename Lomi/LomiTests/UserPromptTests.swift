//
//  UserPromptTests.swift
//  LomiTests
//
//  Created by Takayuki Yamaguchi on 2022-05-31.
//

import XCTest
@testable import Lomi

class UserPromptTests: XCTestCase {
    typealias Prompt = UserPromptStrings
    
    private let NAME_RANGE = AppDefault.NAME_RANGE
    private let PASSWORD_RANGE = AppDefault.PASSWORD_RANGE
    
    // MARK: - FirstNamePrompt
    func testFirstNameEmptyPrompt() {
        let input = ""
        let promptResult = User.firstNamePrompt(input)
        let promptDesired = Prompt.firstName.empty
        XCTAssertEqual(promptResult, promptDesired)
    }

    func testFirstNameTooShortPrompt() {
        if NAME_RANGE.lowerBound > 1 {
            let input = String(repeating: "a", count: NAME_RANGE.lowerBound-1)
            let promptResult = User.firstNamePrompt(input)
            let promptDesired = Prompt.firstName.tooShort(lowerBound: NAME_RANGE.lowerBound)
            XCTAssertEqual(promptResult, promptDesired)
        }
    }

    func testFirstNameTooLongPrompt() {
        let input = String(repeating: "a", count: NAME_RANGE.upperBound+1)
        let promptResult = User.firstNamePrompt(input)
        let promptDesired = Prompt.firstName.tooLong(upperBound: NAME_RANGE.upperBound)
        XCTAssertEqual(promptResult, promptDesired)
    }
    
    func testFirstNamePrompt() {
        let input = String(repeating: "a", count: NAME_RANGE.upperBound)
        let promptResult = User.firstNamePrompt(input)
        let promptDesired = ""
        XCTAssertEqual(promptResult, promptDesired)
    }
    
    
    // MARK: - LastName Prompt
    func testFirstLastEmptyPrompt() {
        let input = ""
        let promptResult = User.lastNamePrompt(input)
        let promptDesired = Prompt.lastName.empty
        XCTAssertEqual(promptResult, promptDesired)
    }

    func testLastNameTooShortPrompt() {
        if NAME_RANGE.lowerBound > 1 {
            let input = String(repeating: "a", count: NAME_RANGE.lowerBound-1)
            let promptResult = User.lastNamePrompt(input)
            let promptDesired = Prompt.lastName.tooShort(lowerBound: NAME_RANGE.lowerBound)
            XCTAssertEqual(promptResult, promptDesired)
        }
    }

    func testLastNameTooLongPrompt() {
        let input = String(repeating: "a", count: NAME_RANGE.upperBound+1)
        let promptResult = User.lastNamePrompt(input)
        let promptDesired = Prompt.lastName.tooLong(upperBound: NAME_RANGE.upperBound)
        XCTAssertEqual(promptResult, promptDesired)
    }
    
    func testLastNamePrompt() {
        let input = String(repeating: "a", count: NAME_RANGE.upperBound)
        XCTAssert(User.lastNamePrompt(input).isEmpty)
    }
    
    
    //MARK: - Email Prompt
    func testInvalidEmailPrompt() {
        let input = "invalid_email_address@.com"
        let promptResult = User.emailPrompt(input)
        let promptDesired = Prompt.email.invalid
        XCTAssertEqual(promptResult, promptDesired)
    }
    
    func testEmailPrompt() {
        let input = "valid_email@address.com"
        let promptResult = User.emailPrompt(input)
        let promptDesired = ""
        XCTAssertEqual(promptResult, promptDesired)
    }
    

    //MARK: - Password Prompt
    func testPasswordEmptyPrompt() {
        let input = ""
        let promptResult = User.passwordPrompt(input)
        let promptDesired = Prompt.password.empty
        XCTAssertEqual(promptResult, promptDesired)
    }

    func testPasswordTooShortPrompt() {
        let input = String(repeating: "a", count: PASSWORD_RANGE.lowerBound-1)
        let promptResult = User.passwordPrompt(input)
        let promptDesired = Prompt.password.tooShort(lowerBound: PASSWORD_RANGE.lowerBound)
        XCTAssertEqual(promptResult, promptDesired)
    }

    func testPasswordTooLongPrompt() {
        let input = "Ab1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-2)
        let promptResult = User.passwordPrompt(input)
        let promptDesired = Prompt.password.tooLong(upperBound: PASSWORD_RANGE.upperBound)
        XCTAssertEqual(promptResult, promptDesired)
    }

    func testPasswordNoUppercasePrompt() {
        let input = "a1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-2)
        let promptResult = User.passwordPrompt(input)
        let promptDesired = Prompt.password.noUppercase
        XCTAssertEqual(promptResult, promptDesired)
    }

    func testPasswordNoLowercasePrompt() {
        let input = "A1" + String(repeating: "A", count: PASSWORD_RANGE.upperBound-2)
        let promptResult = User.passwordPrompt(input)
        let promptDesired = Prompt.password.noLowercase
        XCTAssertEqual(promptResult, promptDesired)
    }

    func testPasswordNoNumberPrompt() {
        let input = "Ab" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-2)
        let promptResult = User.passwordPrompt(input)
        let promptDesired = Prompt.password.noNumber
        XCTAssertEqual(promptResult, promptDesired)
    }

    func testPasswordPrompt() {
        let input = "Ab1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-3)
        let promptResult = User.passwordPrompt(input)
        let promptDesired = ""
        XCTAssertEqual(promptResult, promptDesired)
    }

    
    //MARK: - ConfirmationPassword Prompt
    func testConfirmationPasswordNoMatchPrompt() {
        var inputReEnter = "Ab1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-3)
        let inputOriginal = String(inputReEnter.removeFirst())
        let promptResult = User.confirmationPasswordPrompt(original: inputOriginal, reEnter: inputReEnter)
        let promptDesired = Prompt.password.noMatch
        XCTAssertEqual(promptResult, promptDesired)
    }
    func testConfirmationPasswordEmptyPrompt() {
        let inputReEnter = ""
        let inputOriginal = inputReEnter
        let promptResult = User.confirmationPasswordPrompt(original: inputOriginal, reEnter: inputReEnter)
        let promptDesired = Prompt.password.empty
        XCTAssertEqual(promptResult, promptDesired)
    }
    
    func testConfirmationPasswordTooShortPrompt() {
        let inputReEnter = String(repeating: "a", count: PASSWORD_RANGE.lowerBound-1)
        let inputOriginal = inputReEnter
        let promptResult = User.confirmationPasswordPrompt(original: inputOriginal, reEnter: inputReEnter)
        let promptDesired = Prompt.password.tooShort(lowerBound: PASSWORD_RANGE.lowerBound)
        XCTAssertEqual(promptResult, promptDesired)
    }
    
    func testConfirmationPasswordTooLongPrompt() {
        let inputReEnter = "Ab1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-2)
        let inputOriginal = inputReEnter
        let promptResult = User.confirmationPasswordPrompt(original: inputOriginal, reEnter: inputReEnter)
        let promptDesired = Prompt.password.tooLong(upperBound: PASSWORD_RANGE.upperBound)
        XCTAssertEqual(promptResult, promptDesired)
    }
    
    func testConfirmationPasswordNoUppercasePrompt() {
        let inputReEnter = "a1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-2)
        let inputOriginal = inputReEnter
        let promptResult = User.confirmationPasswordPrompt(original: inputOriginal, reEnter: inputReEnter)
        let promptDesired = Prompt.password.noUppercase
        XCTAssertEqual(promptResult, promptDesired)
    }
    
    func testConfirmationPasswordNoLowercasePrompt() {
        let inputReEnter = "A1" + String(repeating: "A", count: PASSWORD_RANGE.upperBound-2)
        let inputOriginal = inputReEnter
        let promptResult = User.confirmationPasswordPrompt(original: inputOriginal, reEnter: inputReEnter)
        let promptDesired = Prompt.password.noLowercase
        XCTAssertEqual(promptResult, promptDesired)
    }
    
    func testConfirmationPasswordNoNumberPrompt() {
        let inputReEnter = "Ab" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-2)
        let inputOriginal = inputReEnter
        let promptResult = User.confirmationPasswordPrompt(original: inputOriginal, reEnter: inputReEnter)
        let promptDesired = Prompt.password.noNumber
        XCTAssertEqual(promptResult, promptDesired)
    }
    
    func testConfirmationPasswordPrompt() {
        let inputReEnter = "Ab1" + String(repeating: "a", count: PASSWORD_RANGE.upperBound-3)
        let inputOriginal = inputReEnter
        let promptResult = User.confirmationPasswordPrompt(original: inputOriginal, reEnter: inputReEnter)
        let promptDesired = ""
        XCTAssertEqual(promptResult, promptDesired)
    }

}
