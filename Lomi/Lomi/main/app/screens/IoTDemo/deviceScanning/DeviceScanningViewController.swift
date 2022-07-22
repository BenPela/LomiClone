//
//  DeviceListViewModel.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-20.
//

import Foundation

final class DeviceScanningViewController: ObservableObject {
    private static let devicePrefix: String = "LOMI"
    @Published var devices: [ProvisionDevice] = []
    @Published var isProcessing = false
    @Published var reScanRemainingTime: Int = 0
    private let provisionDeviceBleService: ProvisionDeviceBleService
    private var autoScanTask: Task<(), Never>? = nil
    
    init(provisionDeviceBleService: ProvisionDeviceBleService = ProvisionDeviceBleService()) {
        self.provisionDeviceBleService = provisionDeviceBleService
    }
}
    

// MARK: - Binding & Services
extension DeviceScanningViewController {

    @MainActor
    func scanBleDevices() {
        Task {
            isProcessing = true
            devices = await provisionDeviceBleService.fetchAvailableDevices(prefix: DeviceScanningViewController.devicePrefix)
            isProcessing = false
        }
    }
    
    func deleteBleDevice() {
        provisionDeviceBleService.deleteCurrentDevice()
    }

    func stopScan() {
        provisionDeviceBleService.stopFetchDevicesIfNeeded()
    }

    @MainActor
    func scanBleDevicesRepeatedly(interval: Int) {
        autoScanTask = Task {
            defer {
                SystemLogger.log.debug(messages: "\(#function): Task canceled")
                reScanRemainingTime = 0
            }
            
            while Task.isCancelled != true {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if self.reScanRemainingTime == 0 {
                    self.stopScan()
                    self.reScanRemainingTime = interval
                    self.scanBleDevices()
                }
                self.reScanRemainingTime -= 1
            }
        }
    }
    
    func cancelAllTasks() {
        stopScan()
        autoScanTask?.cancel()
    }
  
}
