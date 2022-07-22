//
//  ConfirmationButton.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-04.
//

import Foundation
import SwiftUI

/// A confirmation button. This has disable status and its UI
struct ButtonBase: View {
    var text: String
    var disabled: Bool
    /// If this is true, the width will be same as parent view. Default is true
    var fullWidth: Bool
    /// Display icon on left side if needed.
    var iconSystemName: String?
    var color: Color
    var gradient: LinearGradient?
    var action: () -> Void
    
    init(
        text: String,
        disabled: Bool = false,
        fullWidth: Bool = true,
        iconSystemName: String? = nil,
        color: Color = .ctaSoftForest,
        gradient: LinearGradient? = nil,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.disabled = disabled
        self.fullWidth = fullWidth
        self.iconSystemName = iconSystemName
        self.color = color
        self.gradient = gradient
        self.action = action
    }
    
    var body: some View {
        
        Button(action: action){
            
            HStack(alignment: .center, spacing: 16) {
                if let iconSystemName = iconSystemName {
                    Image(systemName: iconSystemName)
                        .foregroundColor(disabled ? .disabled : .primaryWhite)
                }
                Text(text)
                    .font(.body)
                    .foregroundColor(disabled ? .disabled : .white)
                    .padding(.vertical)
                
            }
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal)
            .background(gradient != nil ? Color.clear : disabled ? .primaryWhite : color)
            .background(gradient)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(disabled ? .disabled : Color.clear, lineWidth: 2)
            )
            .ctaButtonShadow(disable: disabled)
            .cornerRadius(6)
        }
        .frame(height: 52)
        .disabled(disabled)
        .accessibilityIdentifier("\(text)_BUTTON".identifierFormat())
    }
}

struct ConfirmationButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ButtonBase(text: "Button Text", disabled: true, action:{})
            ButtonBase(text: "Button Text", disabled: false, action:{})
            ButtonBase(text: "Button Text", disabled: false, gradient: LinearGradient.vertical(), action:{})
            ButtonBase(text: "Button Text", iconSystemName: "trash.fill", action:{})
            ButtonBase(text: "Button Text", fullWidth: true, iconSystemName: "trash.fill", color: .alert, action:{})
            ButtonBase(text: "Button Text", disabled: true, fullWidth: true, iconSystemName: "trash.fill", color: .alert, action:{})
            ButtonBase(text: "Button Text", fullWidth: false, iconSystemName: "trash.fill", action:{})
            ButtonBase(text: "Button Text", fullWidth: true, iconSystemName: "trash.fill", gradient: LinearGradient.horizontal(startColor: Color.alert, endColor: Color.ctaSoftForest), action:{})
            ButtonBase(text: "Diagonal Gradient", fullWidth: true, gradient: LinearGradient.diagonal(direction: (vertical: VerticalDirection.BottomToTop, horizontal: HorizontalDirection.RightToLeft), color: (start: Color.black, end: Color.white)), action: {})
        }
    }
}
