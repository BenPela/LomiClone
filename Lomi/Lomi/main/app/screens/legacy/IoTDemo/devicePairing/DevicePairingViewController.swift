//
//  DeviceSessionViewModel.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-21.
//

import Foundation

final class DevicePairingViewController: ObservableObject {
    @Published var isProcessing: Bool = false
    @Published var isSessionEstablished: Bool? = nil
    @Published var deviceDetails: String = ""
    private let connectBleService: ConnectBleService
    init(connectBleService: ConnectBleService = ConnectBleService()) {
        self.connectBleService = connectBleService
    }
}


// MARK: - Binding & Services
@MainActor
extension DevicePairingViewController {
    /// Try to connect(establish the session) to the device.
    func connect() {
        Task {
            isProcessing = true
            isSessionEstablished = await connectBleService.connect()
            if isSessionEstablished ?? false {
                let deviceMetadata = await connectBleService.fetchDeviceMetadata()
                connectBleService.updateDeviceMetadata(deviceMetadata)
                updateDeviceDetails()
            }
            isProcessing = false
        }
    }
    
    func updateDeviceDetails() {
        guard let device = connectBleService.provisionDeviceBleService.readCurrentDevice() else { return }
        let details =
        """
        Name: \(device.name)
        Serial Number: \(device.metadata?.serialNumber ?? "")
        Mac Address: \(device.metadata?.macAddress ?? "")
        """
        deviceDetails = details
    }
}
