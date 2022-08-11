//
//  User.swift
//  Lomi
//
//  Created by Peter Harding on 2022-05-16.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    // FIXME: match this model to our desired user model after checking Cognito user response
    var createdAt: String? // ISO date string // TODO: Date type?
    var createdByApiClient: LomiApiClientDetails?
    var metadata: [Metadata]

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case email
        case createdAt
        case createdByApiClient
        case metadata
    }

}


// MARK: - Validation logic
extension User {
    typealias Prompt = UserPromptStrings
    
    static func firstNamePrompt(_ firstName: String) -> String {
        let count = firstName.sanitized.count
        if count == 0 {
            return Prompt.firstName.empty
        }
        if AppDefault.NAME_RANGE.lowerBound > count {
            return Prompt.firstName.tooShort(lowerBound: AppDefault.NAME_RANGE.lowerBound)
        }
        if AppDefault.NAME_RANGE.upperBound < count {
            return Prompt.firstName.tooLong(upperBound: AppDefault.NAME_RANGE.upperBound)
        }
        return ""
    }
    
    static func lastNamePrompt(_ lastName: String) -> String {
        let count = lastName.sanitized.count
        if count == 0 {
            return Prompt.lastName.empty
        }
        if AppDefault.NAME_RANGE.lowerBound > count {
            return Prompt.lastName.tooShort(lowerBound: AppDefault.NAME_RANGE.lowerBound)
        }
        if AppDefault.NAME_RANGE.upperBound < count {
            return Prompt.lastName.tooLong(upperBound: AppDefault.NAME_RANGE.upperBound)
        }
        return ""
    }
    
    static func emailPrompt(_ email: String) -> String {
        if (!RegexHelper.isValidEmail(text: email)) {
            return Prompt.email.invalid
        }
        return ""
    }

    static func passwordPrompt(_ password: String) -> String {
        let count = password.count
        if count == 0 {
            return Prompt.password.empty
        }
        if AppDefault.PASSWORD_RANGE.lowerBound > count {
            return Prompt.password.tooShort(lowerBound: AppDefault.PASSWORD_RANGE.lowerBound)
        }
        if AppDefault.PASSWORD_RANGE.upperBound < count {
            return Prompt.password.tooLong(upperBound: AppDefault.PASSWORD_RANGE.upperBound)
        }
        if !RegexHelper.hasAtLeastOneUppercase(text: password) {
            return Prompt.password.noUppercase
        }
        if !RegexHelper.hasAtLeastOneLowercase(text: password) {
            return Prompt.password.noLowercase
        }
        if !RegexHelper.hasAtLeastOneNumber(text: password) {
            return Prompt.password.noNumber
        }
        return ""
    }
    
    static func confirmationPasswordPrompt(original:String, reEnter:String) -> String {
        if original != reEnter {
            return Prompt.password.noMatch
        }
        let count = reEnter.count
        if count == 0 {
            return Prompt.password.empty
        }
        if AppDefault.PASSWORD_RANGE.lowerBound > count {
            return Prompt.password.tooShort(lowerBound: AppDefault.PASSWORD_RANGE.lowerBound)
        }
        if AppDefault.PASSWORD_RANGE.upperBound < count {
            return Prompt.password.tooLong(upperBound: AppDefault.PASSWORD_RANGE.upperBound)
        }
        if !RegexHelper.hasAtLeastOneUppercase(text: reEnter) {
            return Prompt.password.noUppercase
        }
        if !RegexHelper.hasAtLeastOneLowercase(text: reEnter) {
            return Prompt.password.noLowercase
        }
        if !RegexHelper.hasAtLeastOneNumber(text: reEnter) {
            return Prompt.password.noNumber
        }
        return ""
    }
}
