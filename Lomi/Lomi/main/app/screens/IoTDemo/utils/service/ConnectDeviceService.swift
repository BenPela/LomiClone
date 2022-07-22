//
//  ConnectDeviceService.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-29.
//
import Foundation

protocol ConnectDeviceService {
    func connect() async -> Bool
    func disconnect()
    func sendCustomData(path: String, data: Data) async -> Data?
    func sendWifiCredential(_ ssid: String, _ wifiPassword: String) async -> Bool
}

class ConnectBleService {
    let provisionDeviceBleService: ProvisionDeviceBleService
    private var isSendingWifiCredentials: Bool = false
    private var isConnecting: Bool = false
    
    init(provisionDeviceBleService: ProvisionDeviceBleService = ProvisionDeviceBleService()) {
        self.provisionDeviceBleService = provisionDeviceBleService
    }
}

// MARK: - protocol functions
extension ConnectBleService: ConnectDeviceService {

    func connect() async -> Bool {
        
        if isConnecting {
            SystemLogger.log.debug(messages: "\(#function): Already trying to connect. Deny the latest request.")
            return false
        }
        
        guard let espDevice = provisionDeviceBleService.readCurrentDevice()?.espDevice else {
            SystemLogger.log.debug(messages: "\(#function): Failure. Device not found")
            return false
        }
        
        return await withCheckedContinuation{ continuation in
            SystemLogger.log.debug(messages: "\(#function): Start")
            isConnecting = true

            espDevice.connect() { [weak self] status in
                switch status {
                case .connected:
                    SystemLogger.log.debug(messages: "\(#function): Success!🎉")
                    continuation.resume(returning: true)
                case let .failedToConnect(error):
                    SystemLogger.log.error(messages: "\(#function): \(error)")
                    fallthrough
                case .disconnected:
                    SystemLogger.log.debug(messages: "\(#function): disconnected")
                    fallthrough
                default:
                    SystemLogger.log.debug(messages: "Session establishing is failed...🫠 \n We will disconnect the device")
                    continuation.resume(returning: false)
                    espDevice.disconnect()
                }

                self?.isConnecting = false

            }
        }
    }
    
    func disconnect() {
        SystemLogger.log.debug(messages: "\(#function): Try disconnecting")
        guard let espDevice = provisionDeviceBleService.readCurrentDevice()?.espDevice else {
            SystemLogger.log.debug(messages: "\(#function): Device not found")
            return
        }
        espDevice.disconnect()
        // TODO: Implement completion handler?
    }
    
    
    /// Send custom data to the connected device. To use this function, the device has to be connected to the app.
    /// - Parameters:
    ///   - path: end point of sending data
    ///   - data: data to send the device
    /// - Returns: response from the device
    func sendCustomData(path: String, data: Data) async -> Data? {
        await withCheckedContinuation{ continuation in
            SystemLogger.log.debug(messages: "\(#function): Start")
            guard let espDevice = provisionDeviceBleService.readCurrentDevice()?.espDevice else {
                SystemLogger.log.debug(messages: "\(#function): Device not found")
                continuation.resume(returning: nil)
                return
            }
            
            espDevice.sendData(path: path, data: data) { data, error in
                if let error = error {
                    SystemLogger.log.error(messages: "\(#function): \(error)")
                    continuation.resume(returning: nil)
                    return
                }
                
                SystemLogger.log.debug(messages: "\(#function): success")
                continuation.resume(returning: data)
            }
        }
    }
    
    func sendWifiCredential(_ ssid: String, _ wifiPassword: String) async -> Bool {
        if isSendingWifiCredentials {
            SystemLogger.log.debug(messages: "\(#function): Already processing. Deny the new request")
            return false
        }
        
        return await withCheckedContinuation{ continuation in
            SystemLogger.log.debug(messages: "\(#function): Start")
            
            guard let espDevice = provisionDeviceBleService.readCurrentDevice()?.espDevice else {
                continuation.resume(returning: false)
                SystemLogger.log.debug(messages: "\(#function): Device not found")
                return
            }
            
            isSendingWifiCredentials = true
            espDevice.provision(ssid: ssid, passPhrase: wifiPassword) { [weak self] status in
                switch status {
                case .success:
                    SystemLogger.log.debug(messages:"\(#function): Success!🎉")
                    continuation.resume(returning: true)
                case let .failure(error):
                    switch error {
                    case .configurationError:
                        SystemLogger.log.error(messages: "\(#function): Network configuration. Password may incorrect.")
                    case .sessionError:
                        SystemLogger.log.error(messages: "Session is not established")
                    case .wifiStatusDisconnected:
                        SystemLogger.log.error(messages: "\(#function): Wifi disconnected")
                    default:
                        SystemLogger.log.error(messages: "\(#function): \(error)")
                    }
                    continuation.resume(returning: false)
                case .configApplied:
                    SystemLogger.log.debug(messages: "\(#function): Config has been Applied. Processing....")
                }
                
                self?.isSendingWifiCredentials = false
                return
            }
        }
    }
}


// MARK: - others
extension ConnectBleService {
    
    /// Fetch device metadata from the device
    /// - Returns: metadata from the device
    func fetchDeviceMetadata() async -> ProvisionDeviceMetadata? {
        defer {
            SystemLogger.log.debug(messages: "\(#function): End")
        }

        SystemLogger.log.debug(messages: "\(#function): Start")
        /* FIXME: Define what to send, and what data to receive
         - Data to send. This can be empty string
         - Data type and data model of the response. String, json, what kind of property it can have, etc.
         */
        let data = Data("Custom data from the iOS app 🌝.".utf8)
        let response = await sendCustomData(path: "device-metadata", data: data)

        guard let response = response else { return nil }
        
        // FIXME: We will use JSONCodableHelper later.
        // response.dropLast() is to exclude null termination in the json. `\0`
        let metadata = try? JSONDecoder().decode(ProvisionDeviceMetadata.self, from: response.dropLast())

        return metadata
    }
    
    @discardableResult

    func updateDeviceMetadata(_ metadata: ProvisionDeviceMetadata?) -> ProvisionDevice? {
        defer {
            SystemLogger.log.debug(messages: "\(#function): End")
        }
        
        SystemLogger.log.debug(messages: "\(#function): Start")
        guard let device = provisionDeviceBleService.readCurrentDevice() else { return nil }
        device.metadata = metadata

        return device
    }
}
