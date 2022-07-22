//
//  Networking.swift
//  Lomi
//
//  Created by Peter Harding on 2022-04-21.
//

import Foundation

protocol Networking {
    func request<T: Decodable>(_ requestParams: RequestParams) async -> NetworkResponse<T>
}

struct NetworkResponse<T> {
    var result: T?
    var error: NetworkError?
}

struct NetworkError {
    var message: String
    var statusCode: Int
}
