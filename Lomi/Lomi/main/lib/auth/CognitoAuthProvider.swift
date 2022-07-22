//
//  AuthProvider.swift
//  Lomi
//
//  Created by Peter Harding on 2022-07-11.
//

import Foundation
import Amplify
import AmplifyPlugins

protocol AuthProvider {
    func signUp(email: String, password: String) async -> NetworkResponse<SignupResponse>
    func login(email: String, password: String) async -> NetworkResponse<LoginResponse>
}

struct SignupResponse {

}

struct LoginResponse {

}

class CognitoAuthProvider: AuthProvider {

    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            // TODO: staging and release config files are copies of develop
            var amplifyFileName = "amplifyconfiguration-develop" // DEVELOP by default
            #if STAGING
                amplifyFileName = "amplifyconfiguration-staging"
            #elseif RELEASE
                amplifyFileName = "amplifyconfiguration-release"
            #endif
            guard let configFile = Bundle.main.url(forResource: amplifyFileName, withExtension: ".json") else {
                SystemLogger.log.error(tag: .auth, messages: "No amplifyconfiguration.json file")
                return
            }
            SystemLogger.log.info(tag: .auth, messages: "Using amplify configuration: \(amplifyFileName)")
            // Added in https://github.com/aws-amplify/amplify-ios/pull/707
            let amplifyConfig = try AmplifyConfiguration(configurationFile: configFile)
            try Amplify.configure(amplifyConfig)
            SystemLogger.log.info(tag: .auth, messages: "Amplify configured with auth plugin")
        } catch {
            let crashlog = "Failed to initialize Amplify with \(error)"
            SystemLogger.log.error(tag: .auth, messages: crashlog)
            fatalError(crashlog)
        }
    }

    func signUp(email: String, password: String) async -> NetworkResponse<SignupResponse> {
        return await withCheckedContinuation({ continuation in
            Amplify.Auth.signUp(username: email, password: password, listener: { response in
                print("signup response", response)
                continuation.resume(returning: NetworkResponse(
                    result: SignupResponse(),
                    error: nil
                ))
            })
        })

    }

    func login(email: String, password: String) async -> NetworkResponse<LoginResponse> {
        return await withCheckedContinuation({ continuation in
            Amplify.Auth.signIn(username: email, password: password, listener: { response in
                print("login response")
                continuation.resume(returning: NetworkResponse(
                    result: LoginResponse(),
                    error: nil
                ))
            })
        })

    }

}
