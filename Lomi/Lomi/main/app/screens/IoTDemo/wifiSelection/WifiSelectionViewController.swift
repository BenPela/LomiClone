//
//  WifiSelectionViewModel.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-21.
//

import Foundation
import SwiftUI

final class WifiSelectionViewController: ObservableObject {
    @Published var isProcessing: Bool = false
    @Published var wifilist: [ProvisionWifiNetwork] = []
    private let provisionDeviceBleService: ProvisionDeviceBleService
    
    init(provisionDeviceBleService: ProvisionDeviceBleService = ProvisionDeviceBleService()) {
        self.provisionDeviceBleService = ProvisionDeviceBleService()
    }
}


// MARK: - Binding & Services
extension WifiSelectionViewController {
    @MainActor
    /// Fetch wifi list based on the device. This is to send its credential to the IoT device.
    func scanWifi() {
        /*
         Preserve previous request at the UI level.
         The `searchWifi` doesn't have `stop` function.
         So if another call is requested, we preserve previous(on going) request and deny the new one.
         */
        if isProcessing { return }
        Task {
            isProcessing = true
            wifilist = await provisionDeviceBleService.fetchAvailableWifis()
            isProcessing = false
        }
    }
}
