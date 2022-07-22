//
//  ApiErrorResponse.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-12.
//

import Foundation

struct LomiApiErrorResponse: Codable {
    var userErrorMessage: String
    var statusCode: Int?
    var reason: String?
    
    func isUnauthorized() -> Bool {
        return statusCode == 401
    }
    
    func isUnverified() -> Bool {
        return reason == "user.unverified"
    }
}
