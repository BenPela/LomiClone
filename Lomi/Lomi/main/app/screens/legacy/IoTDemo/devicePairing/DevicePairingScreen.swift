//
//  DevicePairingScreen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-04-21.
//

import SwiftUI

/// Screen for establishing the session.
struct DevicePairingScreen: View {
    @StateObject var viewModel: DevicePairingViewController
    
    var body: some View {
        VStack {
            
            if viewModel.isSessionEstablished != true {
                Button {
                    viewModel.connect()
                } label: {
                    Text(viewModel.isProcessing ? "Pairing" : "Start pairing")
                }
                .padding(.vertical, 32 )
            }
            
            switch viewModel.isSessionEstablished {
            case true:
                Text("""
                    Success!🎉 The device has been connected.
                
                
                    Here's your device details

                    \(viewModel.deviceDetails)
                """)
                .padding()

                NavigationLink("Next 👉: Let's send the wifi info to the Lomi") {
                    WifiSelectionScreen(viewModel: WifiSelectionViewController())
                }
            case false:
                Text("Oops!🫠 Looks like the connection didn't work. Please try again.")
            default:
                EmptyView()
            }
            Spacer()
        }
        .padding()
        .accentColor(.blue)
        .disabled(viewModel.isProcessing)
        .onAppear {
            viewModel.connect()
        }
    }
}


// MARK: - Previews
struct DevicePairingScreen_Previews: PreviewProvider {
    static var previews: some View {
        DevicePairingScreen(viewModel: DevicePairingViewController())
    }
}
