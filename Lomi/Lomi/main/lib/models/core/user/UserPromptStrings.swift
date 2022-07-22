//
//  UserStrings.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-05-31.
//

import Foundation

struct UserPromptStrings {
    struct firstName {
        static var empty: String {
            return localizedHelper("firstName.empty")
        }
        static func tooShort(lowerBound: Int) -> String {
            let string = localizedHelper("firstName.tooShort %d")
            return String(format: string, lowerBound)
        }
        static func tooLong(upperBound: Int) -> String {
            let string = localizedHelper("firstName.tooLong %d")
            return String(format: string, upperBound)
        }
    }
    
    struct lastName {
        static var empty: String {
            return localizedHelper("lastName.empty")
        }
        static func tooShort(lowerBound: Int) -> String {
            let string = localizedHelper("lastName.tooShort %d")
            return String(format: string, lowerBound)
        }
        static func tooLong(upperBound: Int) -> String {
            let string = localizedHelper("lastName.tooLong %d")
            return String(format: string, upperBound)
        }
    }
    
    struct email {
        static var invalid: String {
            return localizedHelper("email.invalid")
        }
    }
    
    struct password {
        static var empty: String {
            return localizedHelper("password.empty")
        }
        static func tooShort(lowerBound: Int) -> String {
            let string = localizedHelper("password.tooShort %d")
            return String(format: string, lowerBound)
        }
        static func tooLong(upperBound: Int) -> String {
            let string = localizedHelper("password.tooLong %d")
            return String(format: string, upperBound)
        }
        static var noUppercase: String {
            return localizedHelper("password.noUppercase")
        }
        static var noLowercase: String {
            return localizedHelper("password.noLowercase")
        }
        static var noNumber: String {
            return localizedHelper("password.noNumber")
        }
        static var noMatch: String {
            return localizedHelper("password.noMatch")
        }
    }
}


private extension UserPromptStrings {
    static let defaultTableName = "UserPrompt"
    
    static func localizedHelper(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        
        let tableName = tableName == nil ? defaultTableName : tableName
        return NSLocalizedString(key, tableName: tableName, comment: comment)
    }
}
