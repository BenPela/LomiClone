//
//  DeviceModeSelectViewModel.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-05-24.
//

import Foundation

class DeviceModeSelectViewController: ObservableObject {
    @Published var selectedModeServer: String = ""
    @Published var isRequestSuccess: Bool = false
    @Published var prompt: String = ""
    @Published var isProcessing: Bool = false
    
    private let deviceControlService: DeviceControlService
    
    init(deviceControlService: DeviceControlService = DeviceControlService()) {
        self.deviceControlService = deviceControlService
    }
    
    @MainActor
    func modeSelect(to mode: DeviceMode) {
        Task {
            isProcessing = true
            isRequestSuccess = await deviceControlService.modeSelect(mode)
            updateState(result: isRequestSuccess, mode: mode)
            isProcessing = false
        }
    }
    
    private func updateState(result: Bool, mode: DeviceMode) {
        if result {
            // This logic should belong somewhere, eg inside the enum
            switch mode {
            case .grow:
                selectedModeServer = "Grow"
            case .ecoExpress:
                selectedModeServer = "Eco Express"
            case .lomiApproved:
                selectedModeServer = "Lomi Approved"
            }
            prompt = "Congrats! 🎉 Your Lomi is \(selectedModeServer) mode now!"
        } else {
            prompt = "Oops!🫠 Looks like something is wrong. Please try again."
        }
    }
}
