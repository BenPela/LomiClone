//
//  GetAppInitResponse.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-01.
//

import Foundation

struct GetAppInitResponse: Codable {
    var registrations: Array<Registration>
    var user: User? // in case userId is not sent in request
    var recentTipSummaries: Array<Tip>
}
