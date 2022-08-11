//
//  ProvisionDeviceService.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-05-05.
//

import Foundation
import ESPProvision

protocol ProvisionDeviceService {
    func readCurrentDevice() -> ProvisionDevice?
    func updateCurrentDevice(_ device: ProvisionDevice?) -> ProvisionDevice?
    func deleteCurrentDevice()
}

class ProvisionDeviceBleService {
    private static var device: ProvisionDevice? = nil
    /// This is for preventing multi `scanWifi` calling
    private var isFetchingWifis = false
    /// This is for preventing multi `search` calling
    private var isFetchingDevices = false

    init() { }
    
    init(withCurrentDevice device: ProvisionDevice) {
        self.updateCurrentDevice(device)
    }
}

// MARK: - protocol functions
extension ProvisionDeviceBleService : ProvisionDeviceService {
    func readCurrentDevice() -> ProvisionDevice? {
        return ProvisionDeviceBleService.device
    }

    @discardableResult
    func updateCurrentDevice(_ device: ProvisionDevice?) -> ProvisionDevice? {
        ProvisionDeviceBleService.device?.espDevice?.disconnect()
        ProvisionDeviceBleService.device = nil
        ProvisionDeviceBleService.device = device
        return readCurrentDevice()
    }

    func deleteCurrentDevice() {
        updateCurrentDevice(nil)
    }

    func fetchAvailableDevices(prefix: String = "") async -> [ProvisionDevice] {
        // Stop previous task if needed.
        stopFetchDevicesIfNeeded()
        
        return await withCheckedContinuation{ continuation in
            SystemLogger.log.debug(messages: "\(#function): Start")
            isFetchingDevices = true
            ESPProvisionManager.shared.searchESPDevices(devicePrefix: prefix, transport: .ble) { [weak self] devices, error in
                var response: [ProvisionDevice] = []

                if let error = error {
                    SystemLogger.log.error(messages: "\(#function): \(error.description)")
                }
                if let devices = devices {
                    response = devices.map({ espDevice in
                        ProvisionDevice(espDevice: espDevice)
                    })
                } else {
                    SystemLogger.log.debug(messages: "\(#function): null device")
                }

                continuation.resume(returning: response)
                self?.isFetchingDevices = false

                SystemLogger.log.debug(messages: "\(#function): Finish")
            }
        }
    }
    
    /// Try to stop scanning devices.
    /// `stop` will executed **only `search`processing is on going**.
    func stopFetchDevicesIfNeeded() {
        /*
         This is to prevent library bug. If we call `stopESPDevicesSearch()`, the completion closure of `searchESPDevices` will be executed.
         This is okwhile it's searching. We can (and we should) call `continuation.resume()` to finish the `continuation`.
         However, if it is called when it's not searching, still the completion and `continuation` of the `searchESPDevices` will be executed. This will cause a risk and bug.
         Thus, to prevent this, we call `stop` only if it searching.
         */
        if !isFetchingDevices { return }
        ESPProvisionManager.shared.stopESPDevicesSearch()
        SystemLogger.log.debug(messages: "\(#function): Stop current searching")
    }
    
    func fetchAvailableWifis() async -> [ProvisionWifiNetwork] {
        /*
         This is for prevent multi requests.
         The ESP library doesn't offer `stop scan wifi` as public.
         So instead of stopping the current scan before the request, we set a flag to prevent multi calling.
         */
        if isFetchingWifis {
            SystemLogger.log.debug(messages: "\(#function): Already fetching. Return empty response as temporary")
            return []
        }
        
        return await withCheckedContinuation{ continuation in
            SystemLogger.log.debug(messages: "\(#function): Start")
            guard let device = readCurrentDevice() else {
                continuation.resume(returning: [])
                return
            }
            isFetchingWifis = true
            device.espDevice?.scanWifiList { [weak self] espWifiList, error in
                var response: [ProvisionWifiNetwork] = []
                
                if let error = error {
                    SystemLogger.log.error(messages: "\(#function): \(error.description)")
                }
                
                if let espWifiList = espWifiList {
                    response = espWifiList
                        .sorted { $0.rssi > $1.rssi }
                        .map { espWifi in
                            ProvisionWifiNetwork(espWifiNetwork: espWifi)
                        }
                } else {
                    SystemLogger.log.debug(messages: "\(#function): null wifi list")
                }
                
                continuation.resume(returning: response)
                self?.isFetchingWifis = false
                SystemLogger.log.debug(messages: "\(#function): Finish")
            }
        }
    }
}
