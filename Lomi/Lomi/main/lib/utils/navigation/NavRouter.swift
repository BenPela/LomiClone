//
//  NavRouter.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-07-19.
//

import Foundation

struct NavRouter {
    
    static let entry: NavPath = [.entry]
    struct Entry {
        static let welcome: NavPath = [.entry, .welcome]
        static let signup: NavPath = [.entry, .signup]
        static let login: NavPath = [.entry, .login]
    }
    static let onboarding: NavPath = [.onboarding]
    struct Onboarding {
        static let deviceSelect: NavPath = [.onboarding, .deviceSelect]
    }
}
