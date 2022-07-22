//
//  LoginRequest.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-16.
//

import Foundation

struct AuthenticateRequest: Codable {
    var email: String
    var password: String
}
