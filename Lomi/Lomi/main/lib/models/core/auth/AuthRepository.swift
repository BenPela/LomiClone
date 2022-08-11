//
//  AuthRepository.swift
//  Lomi
//
//  Created by Peter Harding on 2022-07-14.
//

import Foundation

class AuthRepository: Caching {
    var cacheDuration: Double = 60 * 60 * 1000 // TODO: may not need
    var cachedAuth: StoredAuth?
    private var authDataContainer: StateContainer

    init(stateContainer: StateContainer) {
        authDataContainer = stateContainer
    }

    func getAuth() -> Auth? {
        let storedAuth = authDataContainer.fetchFirst(entityName: "StoredAuth") as? StoredAuth
        cachedAuth = storedAuth
        guard let gStoredAuth = storedAuth else { return nil }
        if isCached() {
            return gStoredAuth.toAuth()
        }
        return nil
    }

    func saveAuth(auth: Auth) -> Bool {
        guard let storedAuth = authDataContainer.fetchFirst(entityName: "StoredAuth") as? StoredAuth else {
            return false
        }
        storedAuth.fromAuth(auth: auth)
        let saved = authDataContainer.save(storedAuth)
        if saved { cachedAuth = storedAuth }
        return saved
    }

    func isCached() -> Bool {
        // TODO: logic involving refreshToken
        return true
    }


}
