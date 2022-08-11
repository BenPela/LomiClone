//
//  ProvisionDelegateAdapter.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-30.
//

import Foundation
import ESPProvision

final class ProvisionConnectionDelegateAdapter: ESPDeviceConnectionDelegate {
    private let devicePassword: String
    
    init(_ devicePassword: String) {
        self.devicePassword = devicePassword
    }
    
    func getProofOfPossesion(forDevice: ESPDevice, completionHandler: @escaping (String) -> Void) {
        completionHandler(devicePassword)
    }
}

