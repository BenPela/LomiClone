//
//  Tip.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-03.
//

import Foundation

struct Tip: Codable, Identifiable {
    var id: String
    var createdAt: String
    var title: String
    var image: ApiImage
    var bookmarked: Bool
    var body: String?
    var linkText: String?
    var linkUrl: String?
}
