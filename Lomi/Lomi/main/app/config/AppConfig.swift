//
//  AppConfig.swift
//  Lomi
//
//  Created by Peter Harding on 2022-04-24.
//

import Foundation

struct AppConfig {
    static var infoDict: [String: Any] {
        if let dict = Bundle.main.infoDictionary {
            return dict
        } else {
            fatalError("infoDictionary not found")
        }
    }

    static let domain = "https://" + (infoDict["Base API URL"] as! String)
    static let identifier = infoDict["CFBundleIdentifier"] as? String ?? "no bundle identifier"
}
