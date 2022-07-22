//
//  GetAppInitRequest.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-01.
//

import Foundation

struct GetAppInitRequest: Codable {
    var userId: String // userId is technically optional, but at least in this version of the app we always want to send userId
}
