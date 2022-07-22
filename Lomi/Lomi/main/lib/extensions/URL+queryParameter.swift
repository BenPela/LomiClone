//
//  urlExtensions.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-31.
//

import Foundation

extension URL {
    mutating func appendingQueryParameter(key: String, value: String?) {
        if let value = value {
            guard var urlComponents = URLComponents(string: absoluteString) else { return }
            var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
            urlComponents.queryItems = queryItems
            self = urlComponents.url!
        }
    }
}
