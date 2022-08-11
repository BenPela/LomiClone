//
//  AuthService.swift
//  Lomi
//
//  Created by Peter Harding on 2022-07-14.
//

import Foundation

protocol AuthProvider {
    func signUp(email: String, password: String) async -> NetworkResponse<SignupResponse>
    func login(email: String, password: String) async -> NetworkResponse<LoginResponse>
}

struct SignupResponse {
//    var user: User
//    var auth: Auth
//    var error: NetworkError?
}

struct LoginResponse {

}

class AuthService {
    private let authRepository: AuthRepository
    private let authProvider: AuthProvider

    init(authRespository: AuthRepository, authProvider: AuthProvider) {
        self.authRepository = authRespository
        self.authProvider = authProvider
    }

    func signUp(email: String, password: String) async -> NetworkResponse<SignupResponse> {
        let response = await authProvider.signUp(email: email, password: password)
        if (response.error != nil) {
            SystemLogger.log.warning(tag: .auth, messages: "Signup failed: \(String(describing: response.error?.message))")
        } else {
//            let saved = self.authRepository.saveAuth(auth: response.auth)
//            if (saved) {
//                // success
//            } else {
//                SystemLogger.log.warning(tag: .coreData, messages: "Could not save auth: \(response.auth)")
//            }
        }
        return response
    }

}
