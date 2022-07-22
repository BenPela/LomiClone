//
//  RegexHelper.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-12-15.
//

import Foundation

struct RegexHelper {
    static func hasAtLeastOneUppercase(text: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*?[A-Z]).*")
        return regex.evaluate(with: text)
    }
    static func hasAtLeastOneLowercase(text: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*?[a-z]).*")
        return regex.evaluate(with: text)
    }
    static func hasAtLeastOneNumber(text: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*?[0-9]).*")
        return regex.evaluate(with: text)
    }
    
    // This is unit tested on our server side, and documents with requirements here https://pela.atlassian.net/wiki/spaces/DX/pages/19595277/Email+requirements
    static func isValidEmail(text: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z0-9.+_-]{1,64}@(?=([A-Za-z0-9\\-.]+\\.){1,8})(?!([A-Za-z0-9\\-.]+\\.){9,})[A-Za-z0-9-.]{1,64}$")
        return regex.evaluate(with: text)
    }
}
