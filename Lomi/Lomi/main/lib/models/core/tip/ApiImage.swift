//
//  ApiImage.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-01.
//

import Foundation

struct ApiImage: Codable {
    var url: String
    var alt: String?
    var title: String?
}
