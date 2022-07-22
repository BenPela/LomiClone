//
//  AppLocalStorage.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-02-16.
//

import Foundation

protocol AppLocalStorage {
    var hasLaunched: Bool { get set }
    var isTempUser: Bool { get set }
}

struct LocalStorage: AppLocalStorage {
    private let userDefaults = UserDefaults.standard
    private let tempUserkey = "lomi.isTempUser"
    private let launchedKey = "lomi.hasLaunched"

    var hasLaunched: Bool {
        get {
            return userDefaults.bool(forKey: launchedKey)
        }
        set {
            userDefaults.set(newValue, forKey: launchedKey)
        }
    }
    
    var isTempUser: Bool {
        get {
            return userDefaults.bool(forKey: tempUserkey)
        }
        set {
            userDefaults.set(newValue, forKey: tempUserkey)
        }
    }
}
