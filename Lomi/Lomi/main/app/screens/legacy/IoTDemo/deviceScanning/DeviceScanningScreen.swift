//
//  DeviceListScreen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-20.
//

import SwiftUI

/// Screen for scanning available devices for the connection.
struct DeviceScanningScreen: View {
    @StateObject var viewModel = DeviceScanningViewController()
    
    var body: some View {
        List {
            buttonScan
                .disabled(viewModel.isProcessing)
            buttonStop
            Text("⏱ Auto re-scan after: \(viewModel.reScanRemainingTime) sec")
            
            Text("Scan results")
                .padding(.top, 32)
            scannedDevices
        }
        .accentColor(.blue)
        .onAppear {
            viewModel.deleteBleDevice()
            viewModel.scanBleDevicesRepeatedly(interval: 10)
        }
        .onDisappear {
            viewModel.cancelAllTasks()
        }
    }
}


// MARK: - subviews
extension DeviceScanningScreen {
    var buttonScan: some View {
        Button  {
            viewModel.scanBleDevices()
        } label: {
            Text(viewModel.isProcessing ? "Scanning" : "🔦 Scan device manually")
                .padding()
        }
    }
    
    var buttonStop: some View {
        Button  {
            viewModel.stopScan()
        } label: {
            Text("🚫 Stop scanning manually")
        }
    }
    
    var scannedDevices: some View {
        ForEach($viewModel.devices, id: \.name) { $device in
            NavigationLink("\(device.name)") {
                DevicePairingScreen(
                    viewModel: DevicePairingViewController(
                        connectBleService: ConnectBleService(
                            provisionDeviceBleService: ProvisionDeviceBleService(withCurrentDevice: device)
                        )
                    )
                )
            }
        }
        .navigationBarTitle("Device List")
    }
}


// MARK: - Previews
struct DeviceListScreen_Previews: PreviewProvider {
    static var previews: some View {
        DeviceScanningScreen()
    }
}
