//
//  UserRepository.swift
//  Lomi
//
//  Created by Peter Harding on 2022-06-30.
//

import Foundation

class UserRepository: Caching {
    var cacheDuration: Double = 60 * 60 * 1000 // 1 hour
    var cachedUser: StoredUser?
    private var userDataContainer: StateContainer

    init(stateContainer: StateContainer) {
        userDataContainer = stateContainer
    }

    func getUser() -> User? {
        let storedUser = userDataContainer.fetchFirst(entityName: "StoredUser") as? StoredUser
        cachedUser = storedUser
        guard let gStoredUser = storedUser else { return nil }
        if isCached() {
            return gStoredUser.toUser()
        }
        return nil // cache expired
    }

    func saveUser(user: User) -> Bool {
        guard let storedUser = userDataContainer.fetchFirst(entityName: "StoredUser") as? StoredUser else {
            return false
        }
        storedUser.fromUser(user: user)
        let saved = userDataContainer.save(storedUser)
        if saved { cachedUser = storedUser }
        return saved
    }

    func isCached() -> Bool {
        // FIXME: better optional unwrap from StoredUser
        guard let lastUpdate = cachedUser?.lastUpdate else { return false }
        let now = NSDate().timeIntervalSince1970
        return now < lastUpdate + cacheDuration
    }


}
