//
//  UITextField+setupStyle.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-03-24.
//

import Foundation
import UIKit

extension UITextField {
    
    /// Setup textfield style based on the input type
    /// - Parameter type: `InputType`
    func setupStyle(_ type: InputType) {
        self.autocorrectionType = .no
        
        switch type {
        case .firstName:
            self.textContentType = .givenName
        case .lastName:
            self.textContentType = .familyName
        case .email:
            self.autocapitalizationType = .none
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .deviceNickname:
            self.autocapitalizationType = .sentences
            self.textContentType = .nickname
        case .deviceSerialNumber:
            self.keyboardType = .numberPad
        case .password, .confirmationPassword:
            self.autocapitalizationType = .none
            self.textContentType = .password
        }
    }
}
