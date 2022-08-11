//
//  EditDeviceNameViewModel.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-12.
//

import Foundation
import SwiftUI

final class EditDeviceNameViewModel: ObservableObject {
    
    @Published var device: Device
    @Published var isLoading: Bool = false
    
    init(device: Device) {
        self.device = device
    }
    
    var nicknamePrompt: String {
        device.nicknamePrompt
    }
    
    func isAllValid() -> Bool {
        device.isAllValid()
    }
}


