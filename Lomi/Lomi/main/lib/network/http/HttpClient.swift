//
//  HttpClient.swift
//  Lomi
//
//  Created by Chris Worman on 2021-10-12.
//

import Foundation

// A protocol for an HTTP client that supports common use cases, such as POST'ing JSON to a URL.
protocol HttpClient {
    func postJson<BodyType: Codable>(
        url: URL,
        body: BodyType,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    )
    
    func putJson<BodyType: Codable>(
        url: URL,
        body: BodyType,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    )
    
    func patchJson<BodyType: Codable>(
        url: URL,
        body: BodyType,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    )
    
    func get(
        url: URL,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    )
    
    func delete(
        url: URL,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    )
}
