//
//  ModeTab.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-16.
//

import Foundation
import SwiftUI

/// A tab button used in the mode screen
struct ModeTab: View {
    /// Id of tab currently selected
    @Binding var selectedId: DeviceMode
    /// id of this tab
    var tabId: DeviceMode
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(selectedId == tabId ? .primaryWhite: .primaryIndigoGreen)
                    .frame(maxWidth: .infinity, minHeight: 36, alignment: .center)
            }
        )
            .background(
                LinearGradient(gradient: Gradient(colors: selectedId == tabId ? [.primaryIndigoGreen, .ctaSoftForest] : [.primaryWhite]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius:5)
                    .stroke(selectedId == tabId ? Color.clear :Color.primaryIndigoGreen, lineWidth: 1)
            )
            .ctaButtonShadow()
    }
}


struct ModeTab_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.white.ignoresSafeArea(.all)
            VStack(alignment: .center, spacing: 32) {
                ModeTab(selectedId: Binding.constant(.grow), tabId: .grow, label: "Label", action: {})
                ModeTab(selectedId: Binding.constant(.grow), tabId: .lomiApproved, label: "Label", action: {})
            }
        }.padding()
    }
}
