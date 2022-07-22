//
//  ModeSelectScreen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-05-20.
//

import SwiftUI

struct DeviceModeSelectScreen: View {
    @ObservedObject var viewModel: DeviceModeSelectViewController
    
    var body: some View {
        VStack {
            Text("Current Lomi mode: ")
            Text("\(viewModel.selectedModeServer)")
                .font(.largeTitle)
                .padding()
            Text("\(viewModel.prompt)")
            
            List {
                Section {
                    Button {
                        viewModel.modeSelect(to: .grow)
                    } label: {
                        Text("Grow")
                    }
                }
                Section {
                    Button {
                        viewModel.modeSelect(to: .ecoExpress)
                    } label: {
                        Text("Eco Express")
                    }
                }
                Section {
                    Button {
                        viewModel.modeSelect(to: .lomiApproved)
                    } label: {
                        Text("Lomi Approved")
                    }
                }
            }
        }
        .accentColor(.blue)
        .disabled(viewModel.isProcessing)

    }
}

struct DeviceModeSelectScreen_Previews: PreviewProvider {
    static var previews: some View {
        DeviceModeSelectScreen(viewModel: DeviceModeSelectViewController())
    }
}
