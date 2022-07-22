//
//  UserService.swift
//  Lomi
//
//  Created by Peter Harding on 2022-05-16.
//

import Foundation

class UserService {
    private let baseURL = URL(string: AppConfig.domain + "/users")!
    private let networkService: Networking

    init(networkService: Networking) {
        self.networkService = networkService
    }

    func createUser(_ user: CreateUserRequest) async -> CreateUserResponse? {
        guard let requestData = JSONCodableHelper.encode(user) else {
            return nil // could not encode, error will be logged by JSONCodableHelper
        }
        let reqParams = RequestParams(url: baseURL, httpMethod: .POST, body: requestData)
        // FIXME: server should return whole user object
        let response: NetworkResponse<CreateUserResponse> = await networkService.request(reqParams)
        if (response.result == nil) {
            // FIXME: handle "account already exists" and other errors gracefully
        }
        return response.result
    }
}

struct CreateUserRequest: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
}

struct CreateUserResponse: Codable {
    var userId: String
}
