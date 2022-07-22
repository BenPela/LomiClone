//
//  DeviceIcon.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-22.
//

import Foundation
import SwiftUI

// A home screen device icon
struct DeviceIcon: View {
    
    var text: String = ""
    var isAddButton: Bool = false
    var isDisabled: Bool = false
    var maxSize: CGFloat = 80
    
    private let paddingRatio: CGFloat = 6.6
    private let borderRatio: CGFloat = 5
    private let maxLineLength: CGFloat = 7
    private let lineGrowthMultiplier: CGFloat = 2
    private func calculateWidth(text: String) -> CGFloat {
        let wordList = text.split(separator: " ")
                
        // If longest word is longer than the line limit on most devices
        let maxWordLength = CGFloat((wordList.max(by: {$1.count > $0.count}) ?? "").count)
        let offset = max(0, (maxWordLength - maxLineLength) * lineGrowthMultiplier)
        return maxSize + offset
    }
    
    private func DeviceIconText(text: String) -> some View {
        let wordList = text.split(separator: " ")
        let width = calculateWidth(text:text)
        let padding = width > maxSize || wordList.count > 3 ? width/paddingRatio : 0
        
        var view: some View {
            
             
            Text(text)
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundColor(.primaryIndigoGreen)
                .frame(width: width, height: maxSize)
                .padding([.leading, .trailing], padding)
        }
        
        return view
    }
        
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            if isAddButton {
                LinearGradient.vertical()
                    .mask(
                        Image(systemName: "plus")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    )
                    .padding(.all, maxSize/paddingRatio)
                    .display(!isDisabled)
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.all, maxSize/paddingRatio)
                    .foregroundColor(Color.white.opacity(0.4))
                    .display(isDisabled)
            } else {
                DeviceIconText(text: text)
            }
        }
        .background(!isDisabled ? Color.primaryWhite : Color.clear)
        .cornerRadius(maxSize/borderRatio)
        .shadow(color: Color.dropShadowBlack.opacity(0.35), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: maxSize/borderRatio)
                .stroke(!isDisabled ? Color.primaryIndigoGreen : Color.white.opacity(0.4), lineWidth: 2)
            
        )
        .frame(width: isAddButton ? maxSize : nil, height: isAddButton ? maxSize : nil)
        
    }
}

struct DeviceIcon_Previews: PreviewProvider {
    static var previews: some View {
        
        ScrollView(.horizontal) {
            VStack {
                DeviceIcon(isAddButton: true, maxSize: 32)
                DeviceIcon(text: "Preview Button")
                DeviceIcon(text: "HelloFrands")
                DeviceIcon(text: "HelloFrandsOneTwoThreeFourFive")
                DeviceIcon(text: "HelloFrands OneTwoThreeFourFive")
                DeviceIcon(text: "Should be two lines")
                DeviceIcon(text: "Should be two lines but there is many will this overflow probably maybe idk who knows")
            }
            .frame(height: .infinity, alignment: .leading)
            .padding(.all, 2)
            
        }
        
        
        HStack {
            DeviceIcon(isAddButton: true, isDisabled: true)
        }
        .background(LinearGradient.vertical().frame(width: 900, height: 80, alignment: .leading))
        
    }
}
