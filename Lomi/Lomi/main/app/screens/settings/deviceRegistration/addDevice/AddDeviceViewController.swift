//
//  DeviceRegistrationViewModel.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-10.
//

import Foundation

final class AddDeviceViewController: ObservableObject {
    
    @Published var device: Device
    @Published var showingSuccess: Bool = false
    @Published var isLoading: Bool = false
    
    init(device: Device) {
        self.device = device
    }
    
    var serialNumberPrompt: String {
        return device.serialNumberPrompt
    }
    
    var nicknamePrompt: String {
        return device.nicknamePrompt
    }
    
    func isAllValid() -> Bool {
        return device.isAllValid()
    }
    
    func isValidSerialNumInput(_ source: String) -> Bool {
        device.isValidSerialNumInput(source)
    }
    
}
