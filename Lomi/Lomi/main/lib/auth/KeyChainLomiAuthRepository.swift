//
//  AuthenticationHelper.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-13.
//

import Foundation
import Security

// A Lomi API auth respository that uses KeyChain as the persistence layer.
class KeyChainLomiAuthRepository: LomiApiAuthRepository {

    static private let authKeychainKey = "lomiApi.auth"
    static private var cachedAuth: LomiApiAuth? = nil
    
    func get() throws -> LomiApiAuth? {
        if let cached = KeyChainLomiAuthRepository.cachedAuth {
            return cached
        }
        
        if let authJson = try getKeychain(key: KeyChainLomiAuthRepository.authKeychainKey) {
            if let authJsonData = authJson.data(using: .utf8) {
                if let auth = try? JSONDecoder().decode(LomiApiAuth.self, from: authJsonData) {
                    let cachedAuth = auth
                    return cachedAuth
                }
            }
        }

        return nil
    }

    func set(auth: LomiApiAuth) throws {
        let authJsonData = try JSONEncoder().encode(auth)
        if let authJson = String(data: authJsonData, encoding: String.Encoding.utf8) {
            try setKeychain(key: KeyChainLomiAuthRepository.authKeychainKey, value: authJson)
            KeyChainLomiAuthRepository.cachedAuth = auth
        } else {
            throw LomiApiAuthRepositoryError.serialization
        }
    }

    func clear() throws {
        try deleteKeychain(key: KeyChainLomiAuthRepository.authKeychainKey)
        KeyChainLomiAuthRepository.cachedAuth = nil
    }
    
    private func setKeychain(key: String, value: String) throws {
        try deleteKeychain(key: key) // Remove existing value if any
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value.data(using: .utf8)!
        ]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        if status != noErr {
            throw LomiApiAuthRepositoryError.storage
        }
    }

    private func getKeychain(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == noErr {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let decodedData = String(data: data, encoding: .utf8)
            {
                return decodedData
            }
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw LomiApiAuthRepositoryError.storage
        }

        return nil
    }

    private func deleteKeychain(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != noErr && status != errSecItemNotFound {
            throw LomiApiAuthRepositoryError.storage
        }
    }
}
