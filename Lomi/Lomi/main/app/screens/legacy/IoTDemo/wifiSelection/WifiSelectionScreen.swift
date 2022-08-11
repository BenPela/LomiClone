//
//  WifiSelectionScreen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-21.
//
import SwiftUI


/// Screen for list up wifi. This is to send the wifi credential to the device
struct WifiSelectionScreen: View {
    @ObservedObject var viewModel: WifiSelectionViewController
    
    var body: some View {
        VStack {
            Text("Select your wifi")
                .font(.title2)
                .fontWeight(.heavy)
            Button {
                viewModel.scanWifi()
            } label: {
                Text(viewModel.isProcessing ? "Scanning" : "Scan Wifi")
            }.padding()
            
            List {
                ForEach(viewModel.wifilist, id: \.ssid) { wifi in
                    NavigationLink("\(wifi.ssid), 📶: \(wifi.rssi)") {
                        DeviceProvisioningScreen(viewModel: DeviceProvisioningViewController(wifiNetwork: wifi))
                    }
                }
            }
        }
        .accentColor(.blue)
        .disabled(viewModel.isProcessing)
        .navigationTitle("Wifi list")
        .onAppear {
            viewModel.scanWifi()
        }
    }
}


// MARK: - Previews
struct WifiSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        WifiSelectionScreen(viewModel: WifiSelectionViewController())
    }
}
