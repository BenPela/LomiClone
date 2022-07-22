//
//  AuthenticationResponse.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-16.
//

import Foundation

struct AuthenticateResponse: Codable {
    var authToken: String
    var user: User
}
