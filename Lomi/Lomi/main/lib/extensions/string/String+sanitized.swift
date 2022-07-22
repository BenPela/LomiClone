//
//  String+sanitized.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-12-15.
//

import Foundation

extension String {
    var sanitized: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
