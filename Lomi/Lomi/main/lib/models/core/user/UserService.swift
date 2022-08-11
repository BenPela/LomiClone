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
    private let userRepsitory: UserRepository // FIXME: depend upon abstraction

    init(networkService: Networking, userRepository: UserRepository) {
        self.networkService = networkService
        self.userRepsitory = userRepository
    }

    func getUser() async -> User? {
        guard let user = userRepsitory.getUser() else {
            let reqParams = RequestParams(url: baseURL)
            let response: NetworkResponse<User> = await networkService.request(reqParams)
            if (response.result == nil) {
                // TODO: could not get user (http)
            }
            let _ = userRepsitory.saveUser(user: response.result!)
            return response.result
        }
        return user
    }

    func createUser(_ user: CreateUserRequest) async -> User? {
        guard let requestData = JSONCodableHelper.encode(user) else {
            return nil // could not encode, error will be logged by JSONCodableHelper
        }
        let reqParams = RequestParams(url: baseURL, httpMethod: .POST, body: requestData)
        // TODO: switch from our networkServie to Amplify / AuthProvider.signUp
        let response: NetworkResponse<CreateUserResponse> = await networkService.request(reqParams)
        
        guard let gResult = response.result else {
            // FIXME: handle "account already exists" and other errors gracefully
            return nil
        }

        let newUser = User(
            id: gResult.userId,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            metadata: []
        )
        let _ = userRepsitory.saveUser(user: newUser)
        return newUser
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
