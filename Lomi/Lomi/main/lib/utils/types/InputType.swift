//
//  InputType.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-06.
//

import Foundation

enum InputType: String {
    // non-secure
    case firstName
    case lastName
    case email
    case deviceNickname
    case deviceSerialNumber
    // secure
    case password
    case confirmationPassword
}


// MARK: - Localization
extension InputType {
    /// Override rawValue so that we can return LocalizedStrings
    var rawValue: String {
        let tableName = "InputType"
        
        switch self {
        case .firstName:
            return NSLocalizedString("firstName", tableName: tableName, value: "First Name", comment: "First name")
        case .lastName:
            return NSLocalizedString("lastName", tableName: tableName, value: "Last Name", comment: "First name")
        case .email:
            return NSLocalizedString("email", tableName: tableName, value: "Email", comment: "Email")
        case .deviceNickname:
            return NSLocalizedString("deviceNickname", tableName: tableName, value: "Nickname", comment: "Nickname for the device")
        case .deviceSerialNumber:
            return NSLocalizedString("deviceSerialNumber", tableName: tableName, value: "Serial number", comment: "Serial number for the device")
        case .password:
            return NSLocalizedString("password", tableName: tableName, value: "Password", comment: "Password")
        case .confirmationPassword:
            return NSLocalizedString("confirmationPassword", tableName: tableName, value: "Re-enter password", comment: "Password used for re-entering so that user can input them correctly")
        }
    }
}


// MARK: - Helpers
extension InputType {
    /// Return if text should be validated only un-focus text-field or whenever users update text
    /// - Returns: `true`: if validating only un-focus. `false`: if validating whenever users update text
    func shouldValidateOnlyUnfocus() -> Bool {
        switch self {
        case .firstName, .lastName, .deviceNickname:
            return true
        default:
            return false
        }
    }
}
