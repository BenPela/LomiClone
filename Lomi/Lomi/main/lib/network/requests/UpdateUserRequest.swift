//
//  UpdateUserRequest.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-08.
//

import Foundation

struct UpdateUserRequest: Codable {
    var _id: String
    var firstName: String?
    var lastName: String?
    // Other user fields are immutable or require dedicated APIs and/or UX flows (eg. password reset)
}
