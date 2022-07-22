//
//  String+IdentifierFormat.swift
//  Lomi
//
//  Created by Ben on 2022-04-13.
//

import Foundation

 extension String {
     public func identifierFormat() -> String {
         self.trimmingCharacters(in: .whitespaces)
             .uppercased()
             .replacingOccurrences(of: " ", with: "_")
     }
 }
