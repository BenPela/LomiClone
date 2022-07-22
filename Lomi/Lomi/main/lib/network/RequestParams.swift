//
//  RequestParams.swift
//  Lomi
//
//  Created by Peter Harding on 2022-04-21.
//

import Foundation

struct RequestParams {
    let url: URL
    let httpMethod: HttpMethod
    let headers: [String: String]
    let body: Data?
    // parameters: [String: String]?

    init(
        url: URL,
        httpMethod: HttpMethod = HttpMethod.GET,
        headers: [String: String] = [:]
    ) {
        self.url = url
        self.httpMethod = httpMethod
        self.headers = headers
        self.body = nil
    }

    init(
        url: URL,
        httpMethod: HttpMethod = HttpMethod.GET,
        headers: [String: String] = [:],
        body: Data
    ) {
        self.url = url
        self.httpMethod = httpMethod
        self.headers = headers
        self.body = body
    }
}
