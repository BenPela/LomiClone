//
//  AuthProvider.swift
//  Lomi
//
//  Created by Peter Harding on 2022-07-11.
//

import Foundation
import Amplify
import AmplifyPlugins

class CognitoAuthProvider: AuthProvider {

    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            // TODO: staging and release config files are copies of develop
            guard let configFile = AppConfig.amplifyConfigURL else { return }
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
                
                // FIXME: Create `User`, `Auth` in SingupResponse
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
