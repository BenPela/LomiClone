//
//  PreviewLocalStorage.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-02-17.
//

import Foundation

/// Local Storage which is used for preview. Since `Preview` shares `UserDefaults.standard`, we need to distinguish them for each preview. To solve this, this struct uses the UUID as key for userDefaults  provisionally and only for preview.
struct PreviewLocalStorage: AppLocalStorage {
    private let userDefaults = UserDefaults.standard
    private let tempUserkey = UUID().uuidString
    private let launchedKey = UUID().uuidString

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
