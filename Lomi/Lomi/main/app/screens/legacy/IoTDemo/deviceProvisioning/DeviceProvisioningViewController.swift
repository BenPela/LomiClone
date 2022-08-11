//
//  DeviceProvisioningViewModel.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-21.
//

import Foundation

final class DeviceProvisioningViewController: ObservableObject {
    @Published var isProcessing: Bool = false
    @Published var isProvisioningSuccess: Bool? = nil
    @Published var wifiPassword = ""
    @Published var processRemainingTime: Int = 0
    private let connectBleService: ConnectBleService
    let wifiNetwork: ProvisionWifiNetwork
    
    init(connectBleService: ConnectBleService = ConnectBleService(),
         wifiNetwork: ProvisionWifiNetwork)
    {
        self.connectBleService = connectBleService
        self.wifiNetwork = wifiNetwork
    }
}


// MARK: - Binding & Services
extension DeviceProvisioningViewController {
    @MainActor
    func sendWifiCredential() {
        Task {
            isProcessing = true
            async let intervalComplete: () = setInterval(intervalSec: 20)
            async let isProvisioningSuccess = connectBleService.sendWifiCredential(wifiNetwork.ssid, wifiPassword)
            
            /*
             Wait both provisioning and the interval are completed.
             This is in case the provisioning has failed. We set the interval so that the firmware have enough time to restart.
             If the provision has succeeded, we cancel the interval so that users don't have to wait.
             */
            if await isProvisioningSuccess {
                processRemainingTime = 0
            }
            await intervalComplete
            
            // Update the UI lastly.
            self.isProvisioningSuccess = await isProvisioningSuccess
            isProcessing = false
        }
    }
    
    /// Set a fake interval. This is for the firmware reset. If the provision fails, a firmware needs enough time for reset and to be prepared.
    /// - Parameter intervalSec: seconds
    /// - Returns: if the interval has finished
    @MainActor private func setInterval(intervalSec: Int) async {
        processRemainingTime = intervalSec
        while processRemainingTime > 0 {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            self.processRemainingTime -= 1
        }
    }
}
