//
//  Screen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-07-19.
//

import Foundation

typealias NavPath = [Screen]
enum Screen: String {
    // Each indent represent hierarchy(group) for each screens. There wasn't a good way to group enum easily, so I used indenting.
    case entry
        case welcome
        case signup
        case login
    case onboarding
        case deviceSelect
    // TODO: Add screen for main menu
    case main
}

