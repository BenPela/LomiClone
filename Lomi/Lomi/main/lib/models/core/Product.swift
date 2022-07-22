//
//  Product.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-26.
//

import Foundation

struct Product: Codable, Identifiable {
    var id: String
    var title: String
    var description: String
    var tags: Array<String>
    var image: ProductImage
    var link: Array<ProductLink>
    var certified: Bool
    var approved: Bool
}

struct ProductLink: Codable {
    var text: String
    var url: String
}

struct ProductImage: Codable {
    var url: String
    var title: String
    var alt: String
}
