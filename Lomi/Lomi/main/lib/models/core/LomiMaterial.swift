//
//  LomiMaterial.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-25.
//

import Foundation

struct LomiMaterial: Codable, Identifiable, Hashable {
    var id: Int { position }
    var position: Int
    var title: String
    var subtitle: String
    var body: String
}
