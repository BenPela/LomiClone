//
//  stringExtensions.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-09.
//

import Foundation

extension String {
    func localized(withComment: String = "") -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
}
