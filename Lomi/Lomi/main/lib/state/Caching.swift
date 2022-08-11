//
//  Caching.swift
//  Lomi
//
//  Created by Peter Harding on 2022-06-30.
//

import Foundation

protocol Caching {
    var cacheDuration: Double { get }
    func isCached() -> Bool
}
