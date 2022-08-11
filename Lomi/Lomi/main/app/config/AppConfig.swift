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
    static let amplifyConfigURL: URL? = {
        guard let filename = infoDict["Amplify config name"] as? String else {
            SystemLogger.log.error(messages: "Could not find amplify configuration file")
            return nil
        }
        
        guard let configFile = Bundle.main.url(forResource: filename, withExtension: "json") else {
            SystemLogger.log.error(tag: .auth, messages: "No amplifyconfiguration.json file")
            return nil
        }
        SystemLogger.log.info(tag: .auth, messages: "Using amplify configuration: \(filename)")
        return configFile
    } ()
}
