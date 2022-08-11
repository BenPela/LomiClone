//
//  DeviceSelectScreen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-07-29.
//

import SwiftUI

struct DeviceSelectScreen: View {
    typealias Strings = DeviceSelectStrings
    
    var goToAddLomiV1: () -> Void
    var goToNameLomiV2: () -> Void
    var goToWebPela: () -> Void
    var goToHome: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Step 1 of 4")
            }
            HStack {
                Text(Strings.screenSubTitle)
                Spacer()
            }
            
            card(
                imagePath: Strings.sourcePath.imageLomiBase,
                title1: Strings.lomiBaseTitle,
                title2: Strings.lomiBaseSubtitle,
                title3: Strings.lomiBaseDetails,
                navigation: goToAddLomiV1
            )
            
            card(
                imagePath: Strings.sourcePath.imageLomiConnect,
                title1: Strings.lomiConnectTitle,
                title2: Strings.lomiConnectSubtitle,
                title3: Strings.lomiConnectDetails,
                navigation: goToNameLomiV2
            )
            
            Button {
                goToWebPela()
            } label: {
                Text(Strings.promptButtonLabel)
            }
            
            Button {
                goToHome()
            } label: {
                Text(Strings.skipButtonLabel)
            }
            
        }
        .onAppear {
            //  Analytics
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("Device Model Selection Screen".identifierFormat())
        
    }
}


extension DeviceSelectScreen {
    @ViewBuilder
    func card(
        imagePath: String,
        title1: String,
        title2: String,
        title3: String,
        navigation: @escaping () -> Void
    ) -> some View {
        
        Button {
            navigation()
        } label: {
            HStack {
                Image(imagePath)
                    .resizable()
                    .scaledToFit()
                VStack {
                    Text(title1)
                    Text(title2)
                    Text(title3)
                }
                Image(systemName: "chevron.right")
            }
        }
    }
}


struct DeviceSelectScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeviceSelectScreen(
                goToAddLomiV1: {},
                goToNameLomiV2: {},
                goToWebPela: {},
                goToHome: {}
            )
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}
