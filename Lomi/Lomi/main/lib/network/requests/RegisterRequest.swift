//
//  RegisterLomiRequest.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-16.
//

import Foundation

struct RegisterRequest: Codable {
    var lomiSerialNumber: String
    var lomiName: String
    var userId: String
}
