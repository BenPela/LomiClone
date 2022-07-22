//
//  SignUpViewModel.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-06.
//

import Foundation
import SwiftUI

final class SignUpViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmationPassword = ""
    
    @Published var isLoading = false
    @Published var showingTermsAndConditions = false
    @Published var showingPrivacyPolicy = false
    
    var firstNamePrompt: String {
        return User.firstNamePrompt(firstName)
    }
    
    var lastNamePrompt: String {
        return User.lastNamePrompt(lastName)
    }
    
    var emailPrompt: String {
        return User.emailPrompt(email)
    }

    var passwordPrompt: String {
        return User.passwordPrompt(password)
    }
    
    var confirmationPasswordPrompt: String {
        return User.confirmationPasswordPrompt(original: password, reEnter: confirmationPassword)
    }
    
    func isAllValid() -> Bool {
        return [firstNamePrompt, lastNamePrompt, emailPrompt, passwordPrompt, confirmationPasswordPrompt].allSatisfy { $0.isEmpty }
    }
}
