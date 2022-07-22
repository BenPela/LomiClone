//
//  GetTipsRequest.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-03.
//

import Foundation

struct GetTipsRequest: Codable {
    var tipId: String?
    var bookmarkUserId: String?
    var bodyFormat: ApiTextFormat? = .markdown
    var onlyBookmarked: Bool?
    var pageSize: Int?
    var pageToken: String?
    var fields: TipFields? = .all
    
    init(tipId: String? = nil, bodyFormat: ApiTextFormat? = .markdown, fields: TipFields? = .all) {
        self.tipId = tipId
        self.bodyFormat = bodyFormat
        self.fields = fields
    }
    
    // TODO: Remove this if we no loger use it.
    init(bookmarkUserId: String, onlyBookmarked: Bool, pageSize: Int, fields: TipFields, pageToken: String?) {
        self.bookmarkUserId = bookmarkUserId
        self.onlyBookmarked = onlyBookmarked
        self.pageSize = pageSize
        self.pageToken = pageToken
        self.fields = fields
    }
}
