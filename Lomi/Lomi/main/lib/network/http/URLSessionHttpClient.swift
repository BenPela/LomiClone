//
//  HttpClient.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-13.
//

import Foundation

// An implementation of the HttpClient protocol using "URLSession.shared.dataTask".
class URLSessionHttpClient: HttpClient {
    
    func postJson<BodyType: Codable>(
        url: URL,
        body: BodyType,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    ) {
        requestWithJsonBody(
            httpVerb: "POST",
            url: url,
            body: body,
            headers: headers,
            onResponse: onResponse,
            onError: onError
        )
    }
    
    func putJson<BodyType: Codable>(
        url: URL,
        body: BodyType,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    ) {
        requestWithJsonBody(
            httpVerb: "PUT",
            url: url,
            body: body,
            headers: headers,
            onResponse: onResponse,
            onError: onError
        )
    }
    
    func patchJson<BodyType: Codable>(
        url: URL,
        body: BodyType,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    ) {
        requestWithJsonBody(
            httpVerb: "PATCH",
            url: url,
            body: body,
            headers: headers,
            onResponse: onResponse,
            onError: onError
        )
    }
    
    func get(
        url: URL,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    ) {
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "GET"

        if let headers = headers {
            for key in headers.keys {
                request.setValue(headers[key], forHTTPHeaderField: key)
            }
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                onResponse(httpResponse, data)
            } else {
                if let error = error {
                    onError(error)
                } else {
                    onError(HttpClientError.unexpected)
                }
            }
        }.resume()
    }
    
    func delete(
        url: URL,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    ) {
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "DELETE"

        if let headers = headers {
            for key in headers.keys {
                request.setValue(headers[key], forHTTPHeaderField: key)
            }
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                onResponse(httpResponse, data)
            } else {
                if let error = error {
                    onError(error)
                } else {
                    onError(HttpClientError.unexpected)
                }
            }
        }.resume()
    }
    
    private func requestWithJsonBody<BodyType: Codable>(
        httpVerb: String,
        url: URL,
        body: BodyType,
        headers: Dictionary<String, String>?,
        onResponse: @escaping (HTTPURLResponse, Data?) -> Void,
        onError: @escaping (Error?) -> Void
    ) {
        guard let bodyJson = try? JSONEncoder().encode(body) else {
            onError(HttpClientError.serialization)
            return
        }
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = httpVerb
        request.httpBody = bodyJson
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headers = headers {
            for key in headers.keys {
                request.setValue(headers[key], forHTTPHeaderField: key)
            }
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                onResponse(httpResponse, data)
                return
            } else {
                if let error = error {
                    onError(error)
                } else {
                    onError(HttpClientError.unexpected)
                }
                return
            }
        }.resume()
    }
}
