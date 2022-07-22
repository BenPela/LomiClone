//
//  AuthRepository.swift
//  Lomi
//
//  Created by Chris Worman on 2021-10-12.
//

import Foundation

// The protocol for a repository that stores Lomi API authentication details.
protocol LomiApiAuthRepository {
    func get() throws -> LomiApiAuth?
    func set(auth: LomiApiAuth) throws
    func clear() throws
}
