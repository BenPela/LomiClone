//
//  DeviceProvisioningScreen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-21.
//

import SwiftUI

/// Screen for providing the wifi credential to the IoT Device
struct DeviceProvisioningScreen: View {
    @EnvironmentObject private var navigationController: NavigationController
    @ObservedObject var viewModel: DeviceProvisioningViewController
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 32) {
                if viewModel.isProvisioningSuccess != true {
                    sendWifiCredential
                }
                
                Divider()
                
                if viewModel.isProcessing {
                    processingIndicator
                } else {
                    provisioningResult
                }
            }
        }
        .padding()
        .accentColor(.blue)
        .disabled(viewModel.isProcessing)
        /* This is for preventing going previous screen
          - while provisioning
          - after provision has succeeded
         */
        .navigationBarBackButtonHidden(viewModel.isProcessing || viewModel.isProvisioningSuccess == true)
    }
}

// MARK: - subviews
extension DeviceProvisioningScreen {
    @ViewBuilder
    var sendWifiCredential: some View {
        Text("Send your wifi password to your Lomi")
            .font(.title2)
            .fontWeight(.heavy)
        
        Text("Your wifi name: \(viewModel.wifiNetwork.ssid)")
        SecureField("Your wifi password", text: $viewModel.wifiPassword)
            .frame(height: 40)
            .background(Color.gray.opacity(0.24))
        
        Button {
            viewModel.sendWifiCredential()
        } label: {
            Text(viewModel.isProcessing ? "Sending..." : "Start sending")
        }
    }
    
    var processingIndicator: some View {
        Text("Processing...⏱ \(viewModel.processRemainingTime) sec.")
            .font(.title3)
    }
    
    @ViewBuilder
    var provisioningResult: some View {
        switch viewModel.isProvisioningSuccess {
        case true:
            Text("""
                Congrats!🎉 You successfully sent the wifi credential to the device.
            """)
            .padding()
            
            Button {
                navigationController.popToRoot()
            } label: {
                Text("Start controlling your Lomi")
            }


        case false:
            Text("Oops!🫠 Looks like it didn't work. Please try again.")
        default:
            EmptyView()
        }
    }
}
