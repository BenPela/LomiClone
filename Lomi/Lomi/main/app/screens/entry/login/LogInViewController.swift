//
//  LogInViewModel.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-09.
//


import Foundation
import SwiftUI


final class LogInViewController: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published var isLoading: Bool = false
    @Published var showingResetPassword: Bool = false
    @Published var alertType: AlertType?
    
    func isAllValid() -> Bool {
        return [emailPrompt, passwordPrompt].allSatisfy{ $0.isEmpty }
    }

    var emailPrompt: String {
        return User.emailPrompt(email)
    }

    var passwordPrompt: String {
        return User.passwordPrompt(password)
    }
}


extension LogInViewController {
    enum AlertType: Identifiable {
        case unauthorized, resendEmailVerificationConfirm
        var id: Int { hashValue }
    }
}
