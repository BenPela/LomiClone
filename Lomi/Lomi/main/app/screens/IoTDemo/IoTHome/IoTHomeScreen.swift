//
//  IoTHomeScreen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-05-11.
//

import SwiftUI

struct IoTHomeScreen: View {
    var body: some View {
        VStack(alignment: .center, spacing: 64) {
            NavigationLink("Let's find your Lomi") {
                DeviceScanningScreen(viewModel: DeviceScanningViewController())
            }
            NavigationLink("Select the Lomi's Mode") {
                DeviceModeSelectScreen(viewModel: DeviceModeSelectViewController())
            }
        }
    }
}

// MARK: - subviews
struct IoTHomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        IoTHomeScreen()
    }
}
