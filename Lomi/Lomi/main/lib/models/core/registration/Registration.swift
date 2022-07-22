//
//  Registration.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-16.
//

import Foundation

struct Registration: Codable, Identifiable {
    var id: String
    var lomiSerialNumber: String
    var lomiName: String
    var userId: String
    var createdAt: String // ISO Date string
    var apiClientDetails: LomiApiClientDetails?

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case lomiSerialNumber
        case lomiName
        case userId
        case createdAt
        case apiClientDetails
    }
}
