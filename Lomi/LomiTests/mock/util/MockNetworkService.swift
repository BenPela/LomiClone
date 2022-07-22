//
//  MockNetworkService.swift
//  LomiTests
//
//  Created by Peter Harding on 2022-04-21.
//

import Foundation
@testable import Lomi

class MockNetworkService: Networking {
    func request<T>(_ requestParams: RequestParams) async -> NetworkResponse<T> where T : Decodable {
        return NetworkResponse(result: nil, error: nil)
    }
}
