//
//  NameLomiV2Controller.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-08-04.
//

import UIKit
import SwiftUI

final class NameLomiV2Controller {
    
// MARK: - Random Nickname
// These properties and logics are to generate random nickname. e.g "Crying Avocado"
// If this is also going to be used in other places, let's encapsulate it as an independent helper, and make it reusable.
    
    private var tableName = "lomiNickName"
    private var sourceKeyLeftDefault = "Lomi"
    private var sourceKeysLeft = [
        "crying",
        "crazy",
        "sleeping",
        "nodding"
    ]
    private var sourceKeyRightDefault = "Connect"
    private var sourceKeysRight = [
        "mango",
        "avocado",
        "eggplant",
        "guava"
    ]
    
    func getRandomName() -> String {
        let keyLeft = getRandomKey(source: sourceKeysLeft)
        let gKeyLeft = keyLeft ?? sourceKeyLeftDefault
        let localizedLeft = getLocalizedString(gKeyLeft, tableName: tableName).capitalized
        
        let keyRight = getRandomKey(source: sourceKeysRight)
        let gKeyRight = keyRight ?? sourceKeyRightDefault
        let localizedRight = getLocalizedString(gKeyRight, tableName: tableName).capitalized
        
        return "\(localizedLeft) \(localizedRight)"
    }
    
    func getRandomKey(source: [String]) -> String? {
        return source.randomElement()
    }
    
    func getLocalizedString(_ key: String , tableName: String? = nil) -> String {
        // Return key if there is no localizable string
        return NSLocalizedString(key, tableName: tableName, value: key, comment: "")
    }
    
    // Optional setup. This is for testing.
    func setupSources(
        sourceKeysLeft: [String] = [],
        sourceKeysRight: [String] = [],
        sourceKeyLeftDefault: String = "",
        sourceKeyRightDefault: String = "",
        localizationTableName: String = ""
    ) {
        self.sourceKeysLeft = sourceKeysLeft
        self.sourceKeysRight = sourceKeysRight
        self.sourceKeyLeftDefault = sourceKeyLeftDefault
        self.sourceKeyRightDefault = sourceKeyRightDefault
        self.tableName = localizationTableName
    }
}
