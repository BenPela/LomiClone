//
//  WelcomeScreenStrings.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-05-30.
//

import Foundation

// MARK: - Localizable
struct WelcomeStrings {
    static private let tableName = "Welcome"
    static let logoCatchphrase = 
    NSLocalizedString("logoCatchphrase", tableName: tableName, value: "Make garbage optional.", comment: "A catchphrase displayed under the logo.")
    static let signInButtonLabel = NSLocalizedString("signInButtonLabel", tableName: tableName, value: "Get started", comment: "A label used for a button which navigates to sign-in screen")
    static let logInButtonLabel = NSLocalizedString("logInButtonLabel", tableName: tableName, value: "Log in", comment: "A label used for a button which navigates to log-in screen")
    static let logInPrompt = NSLocalizedString("logInPrompt", tableName: tableName, value: "Already have an account?", comment: "A text displayed next to the log-in button")
}


// MARK: - Non Localizable
extension WelcomeStrings {
    struct SourcePath {
        static let imageLogo = "lomiLogo"
        static let imageBackground = "welcomeBackground"
    }
}
