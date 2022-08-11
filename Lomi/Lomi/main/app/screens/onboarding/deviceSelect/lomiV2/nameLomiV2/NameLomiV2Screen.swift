//
//  NameLomiV2Screen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-08-04.
//

import SwiftUI

struct NameLomiV2Screen: View {
    typealias Strings = NameLomiV2Strings
    private var goToConnectLomiScreen: (String) -> Void

    @State private var deviceName: String = "Lomi Nickname"
    private let deviceNameDefault: String
    private let viewController: NameLomiV2Controller
    
    init(goToConnectLomiScreen: @escaping (String) -> Void,
         viewController: NameLomiV2Controller
    ) {
        self.goToConnectLomiScreen = goToConnectLomiScreen
        self.viewController = viewController
        self.deviceNameDefault = viewController.getRandomName()
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                // Placeholder step
                Text("Step ? of 4")
            }
            VStack(alignment: .leading, spacing: 16) {
                Text(Strings.nameLomiTitle)
                    .fontWeight(.bold)
                Text(Strings.nameLomiSubTitle)
                TextField("", text: $deviceName)
                    .background(Color.gray)
                
                Button {
                    goToConnectLomiScreen(deviceName)
                } label: {
                    Text(deviceName == deviceNameDefault
                         ? Strings.continueButtonLabel
                         : Strings.continueButtonLabelSave
                    )
                }
                .disabled(deviceName.sanitized.isEmpty)
            }
        }
        .onAppear {
            deviceName = deviceNameDefault
            //  Analytics
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(Strings.screenId.identifierFormat())
        
    }
}

struct NameLomiV2Screen_Previews: PreviewProvider {
    static var previews: some View {
        NameLomiV2Screen(goToConnectLomiScreen: { _ in }, viewController: NameLomiV2Controller())
    }
}
