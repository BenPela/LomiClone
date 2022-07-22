//
//  EditSerialNumberViewModel.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-12.
//

import Foundation
import SwiftUI

final class EditSerialNumberViewModel: ObservableObject {
    
    @Published var device: Device
    @Published var isLoading: Bool = false
    
    init(device: Device) {
        self.device = device
    }
    
    var serialNumberPrompt: String {
        device.serialNumberPrompt
    }
    
    func isAllValid() -> Bool {
        device.isAllValid()
    }
    
    func isValidSerialNumInput(_ source: String) -> Bool {
        device.isValidSerialNumInput(source)
    }
    
    func isValidSerialNum(_ serialNum: String) -> Bool {
        device.isValidSerialNum(serialNum)
    }
}
