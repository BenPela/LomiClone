//
//  ApiAuth.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-13.
//

import Foundation

// Authentication details required for some Lomi API calls.
struct LomiApiAuth: Codable {
    var user: User
    var authToken: String
}

extension LomiApiAuth {
    static let onboardingCompleteKey = "onboardingComplete"
    func isOnboardingComplete() -> Bool {
        guard let onboardingComplete = user.metadata.filter({ $0.key == LomiApiAuth.onboardingCompleteKey }).first else { return false }
        
        return onboardingComplete.value == "true"
    }
}
