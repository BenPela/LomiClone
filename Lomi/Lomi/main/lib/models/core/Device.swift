//
//  Device.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-01-24.
//

import Foundation

struct Device {
    private(set) var registration: Registration?
    
    var serialNumber = AppDefault.SERIAL_NUMBER_PREFIX
    var nickname = ""
    
    init(registration: Registration? = nil) {
        self.registration = registration
        if let registration = registration {
            serialNumber = registration.lomiSerialNumber
            nickname = registration.lomiName
        }
    }
    
    var serialNumberPrompt: String {
        if !isValidSerialNum(serialNumber) {
            return "Your serial number will be an L followed by 11 numbers"
        }
        return ""
    }
    
    var nicknamePrompt: String {
        let count = nickname.sanitized.count
        if count == 0 {
            return "Please enter your nickname"
        }
        if AppDefault.NAME_RANGE.lowerBound > count {
            return "Nickname must be at least \(AppDefault.NAME_RANGE.lowerBound) characters"
        }
        if AppDefault.NAME_RANGE.upperBound < count {
            return "Nickname must be within \(AppDefault.NAME_RANGE.upperBound) characters"
        }
        return ""
    }
    
    func isAllValid() -> Bool {
        return [serialNumberPrompt, nicknamePrompt].allSatisfy { $0.isEmpty }
    }
    
    func isValidSerialNum(_ serialNum: String) -> Bool {
        return isValidSerialNumInput(serialNum) &&
        hasValidSerialNumSuffix(serialNum) &&
        isValidSerialNumLength(serialNum)
    }
    
    func isValidSerialNumInput(_ source: String) -> Bool {
        let digits = String(source.dropFirst(AppDefault.SERIAL_NUMBER_PREFIX.count))
        return (
            source.hasPrefix(AppDefault.SERIAL_NUMBER_PREFIX) &&
            CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: digits)) &&
            source.count <= AppDefault.SERIAL_NUMBER_DIGITS_LENGTH + AppDefault.SERIAL_NUMBER_PREFIX.count
        )
    }
    
    func hasValidSerialNumSuffix(_ serialNum: String) -> Bool {
        let suffix = serialNum.suffix(AppDefault.SERIAL_NUMBER_DIGITS_LENGTH)
        // 4 digits(MMYY) + 6 digits. We only support 21 and 22 as year for v1 lomi.
        let regex = NSPredicate(format: "SELF MATCHES %@", "^(0[1-9]|1[0-2])(2[1-2])([0-9]{6})$")
        return regex.evaluate(with: suffix)
    }
    
    func isValidSerialNumLength(_ serialNum: String) -> Bool {
        return serialNum.count == AppDefault.SERIAL_NUMBER_PREFIX.count + AppDefault.SERIAL_NUMBER_DIGITS_LENGTH
    }
    
}
