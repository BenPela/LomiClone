//
//  RightArrowCell.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-30.
//
import Foundation
import SwiftUI

/// A Cell which has icon (optional), text(title), and arrow button
struct RightArrowCell: View {
    
    private var text: String
    private var icon: Image?
    
    /// No icon
    init(
        text: String
    ) {
        self.text = text
        icon = nil
    }
    
    /// Add icon from sf symbol
    init(
        text: String,
        iconSystemName: String
    ) {
        self.text = text
        if let uiImage =  UIImage(systemName: iconSystemName) {
            icon = Image(uiImage: uiImage)
        }
    }
    
    /// Add icon from asset
    init(
        text: String,
        iconAssetName: String
    ) {
        self.text = text
        if let uiImage =  UIImage(named: iconAssetName) {
            icon = Image(uiImage: uiImage)
        }
    }
    
    var body: some View {
        HStack {
            if let icon = icon {
                icon
                    .renderingMode(.template)
                    .foregroundColor(.primaryIndigoGreen)
                    .frame(width: 16, alignment: .center)
                    .padding(.trailing, 8)
            }
            
            Text(text)
                .accentColor(.primarySoftBlack)
            Spacer()
            
            Image(systemName: "chevron.right")
                .renderingMode(.template)
                .foregroundColor(.primarySoftBlack)
        }
        .padding()
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .leading
        )
    }
    
}


struct RightArrowCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Color.white.ignoresSafeArea(.all)
            RightArrowCell(text: "systemIcon", iconSystemName: "house.fill")
            RightArrowCell(text: "assetIcon", iconAssetName: "lomiApprovedIcon")
            RightArrowCell(text: "icon not found", iconAssetName: "")
            RightArrowCell(text: "no icon")
        }
    }
}
