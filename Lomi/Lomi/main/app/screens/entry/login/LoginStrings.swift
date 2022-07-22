//
//  LoginScreenStrings.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-06-06.
//

import Foundation

// MARK: - Localizable
struct LoginStrings {
    private static let tableName = "Login"
    
    static let signUpPrompt = NSLocalizedString("signUpPrompt", tableName: tableName, comment: "Prompt for navigating sign up screen")
    static let signUpButtonLabel = NSLocalizedString("signUpButtonLabel", tableName: tableName, comment: "A label for sign up button")
    
    static let loginPrompt = NSLocalizedString("loginPrompt" , tableName: tableName, comment: "A prompt(title) for login screen")
    static let loginPromptUnauthorized = NSLocalizedString("loginPromptUnauthorized" , tableName: tableName, comment: "A prompt(title) for login screen when a user is not authorized")
    static let loginButtonLabel = NSLocalizedString("loginButtonLabel", tableName: tableName, comment: "A label for submitting forms + login")
    static let resetPasswordButtonLabel = NSLocalizedString("resetPasswordButtonLabel", tableName: tableName, comment: "A label for reset password screen")
}


// MARK: - Localizable + Alert
// We may need to replace these to different place.
extension LoginStrings {
    struct alert {
        static let loginUnauthorizedTitle = NSLocalizedString("loginUnauthorizedTitle", tableName: tableName, comment: "Error")
        static let loginUnauthorizedMessage = NSLocalizedString("loginUnauthorizedMessage", tableName: tableName, comment: "Error")
        static let loginUnauthorizedConfirm = NSLocalizedString("loginUnauthorizedConfirm", tableName: tableName, comment: "Error")
        
        static let resendEmailTitle = NSLocalizedString("resendEmailTitle", tableName: tableName, comment: "An alert title for asking users to resend their email")
        static func resendEmailMessage(email: String) -> String {
            let localizedString = NSLocalizedString("resendEmailMessage %@", tableName: tableName, comment: "An alert message for asking users to resend their email")
            return String(format: localizedString, email)
        }
        static let resendEmailConfirm = NSLocalizedString("resendEmailConfirm", tableName: tableName, comment: "A  confirm button label for asking if we can resend their email")
    }
}


// MARK: - Non Localizable
extension LoginStrings {
    struct sourcePath {
        static let imageLogo = "logInTop"
    }
}
