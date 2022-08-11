//
//  ProvisioningDevice.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-29.
//

import Foundation
import ESPProvision

class ProvisionDevice {
    var espDevice: ESPDevice? = nil
    var name: String {
        espDevice?.name ?? ""
    }
    var metadata: ProvisionDeviceMetadata? = nil
    
    init(espDevice: ESPDevice? = nil, metadata: ProvisionDeviceMetadata? = nil) {
        self.espDevice = espDevice
        self.metadata = metadata
    }
}

// TODO: Debug print. We will delete this later.
extension ProvisionDevice: CustomStringConvertible {
    var description: String {
        guard let espDevice = espDevice else { return "No esp device" }
        let text = """
                    name: \(espDevice.name),
                    isSessionEstablished: \(espDevice.isSessionEstablished()),
                    advertisementData: \(espDevice.advertisementData ?? [:]),
                    bleDelegate: \(espDevice.bleDelegate.debugDescription ),
                    capabilities: \(espDevice.capabilities ?? []),
                    delegate: \(espDevice.delegate.debugDescription ),
                    espSoftApTransport: \(espDevice.espSoftApTransport.debugDescription),
                    security: \(espDevice.security),
                    securityLayer: \(espDevice.securityLayer.debugDescription),
                    versionInfo: \(espDevice.versionInfo.debugDescription),
                    """
        return text
    }
}


extension ProvisionDevice {
    static let mockBLE = ProvisionDevice(espDevice: ESPDevice(name: "BLE", security: .secure, transport: .ble))
}
