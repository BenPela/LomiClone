//
//  UpdateUserMetadataResponse.swift
//  Lomi
//
//  Created by Scott Clary on 2022-01-10.
//

import Foundation

struct UpdateUserMetadataResponse: Codable {
    var _id: String
    var metadata: [Metadata]
}
