//
//  ServiceLocator.swift
//  Lomi
//
//  Created by Peter Harding on 2022-04-24.
//

import Foundation

protocol ServiceLocating {
    func registerService<T>(_ service: T)
    func resolveService<T>(_ type: T.Type) -> T?
}

class ServiceLocator: ServiceLocating {
    private var registry: [String: Any] = [:]

    func registerService<T>(_ service: T) {
        let key = "\(T.self)"
        registry[key] = service
    }

    // TODO: should this throw an error if the service is not found instead of returning nil ?
    func resolveService<T>(_ type: T.Type) -> T? {
        let key = "\(T.self)"
        return registry[key] as? T
    }
}
