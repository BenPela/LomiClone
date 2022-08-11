//
//  Auth.swift
//  Lomi
//
//  Created by Peter Harding on 2022-07-12.
//

import Foundation

struct Auth: Identifiable {
    var idToken: String
    var accessToken: String
    var refreshToken: String
    var id: String { idToken }
}
