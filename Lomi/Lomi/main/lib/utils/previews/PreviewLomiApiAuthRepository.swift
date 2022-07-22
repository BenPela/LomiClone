//
//  PreviewLomiAuthRepository.swift
//  Lomi
//
//  Created by Chris Worman on 2021-10-13.
//

import Foundation

// An in-memory implementation of the LomiApiAuthRepository protocol, which is meant
// for temporary use in Xcode view previews.
class PreviewLomiApiAuthRepository: LomiApiAuthRepository {
    private var auth: LomiApiAuth? = nil
    
    init(initialAuth: LomiApiAuth? = nil) {
        self.auth = initialAuth
    }
    
    func get() throws -> LomiApiAuth? {
        return auth
    }
    
    func set(auth: LomiApiAuth) throws {
        self.auth = auth
    }
    
    func clear() throws {
        self.auth = nil
    }
}

extension PreviewLomiApiAuthRepository {
    #if DEBUG
    static let mockAuthRepository: LomiApiAuthRepository = PreviewLomiApiAuthRepository(
        initialAuth: LomiApiAuth(
            user: User(
                id: "user-1",
                firstName: "Chris",
                lastName: "Worman",
                email: "chris.worman@pelacase.com",
                createdAt: "2021-10-13T22:35:31.718Z",
                createdByApiClient: LomiApiClientDetails(name: "iOS", version: "1.0.0"),
                metadata: [Metadata(key: "mockKey", value: "mockValue")]
            ),
            authToken: "lomi-auth-token"))
    #else
    static let mockAuthRepository = PreviewLomiApiAuthRepository()
    #endif
}
