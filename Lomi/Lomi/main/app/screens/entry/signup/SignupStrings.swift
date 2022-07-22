//
//  SignUpScreenStrings.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-06-03.
//

import Foundation

struct SignupStrings {
    private static let tableName = "Signup"
    static let logInPrompt = NSLocalizedString("logInPrompt", tableName: tableName, comment: "Prompt for navigating logIn screen")
    static let logInButtonLabel = NSLocalizedString("logInButtonLabel", tableName: tableName, comment: "A label for logIn button")
    static let logoSubtitle = NSLocalizedString("logoSubtitle", tableName: tableName, comment: "A subtitle displayed below the logo above signUp forms")
    static let submitButtonLabel = NSLocalizedString("signUpButtonLabel", tableName: tableName, comment: "A label for button to submit forms")
    static let guestLogInButtonLabel = NSLocalizedString("guestLogInButtonLabel", tableName: tableName, comment: "A label for button to logIn as a guest account")
}


extension SignupStrings {
    struct sourcePath {
        static let imageLogo = "lomiLogo"
    }
}
