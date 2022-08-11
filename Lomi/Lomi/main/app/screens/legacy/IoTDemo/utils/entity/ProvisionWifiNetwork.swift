//
//  WifiNetwork.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-29.
//

import Foundation
import ESPProvision

struct ProvisionWifiNetwork {
    private var espWifiNetwork: ESPWifiNetwork
    
    var ssid: String {
        espWifiNetwork.ssid
    }
    
    var rssi: Int32 {
        espWifiNetwork.rssi
    }
    
    init(espWifiNetwork: ESPWifiNetwork) {
        self.espWifiNetwork = espWifiNetwork
    }
}
