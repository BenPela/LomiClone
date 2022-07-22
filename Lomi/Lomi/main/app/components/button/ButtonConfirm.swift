//
//  ButtonSave.swift
//  Lomi
//
//  Created by Calham Northway on 2022-01-28.
//

import SwiftUI

struct ButtonConfirm: View {
    var text: String
    var disabled: Bool
    /// Display icon on left side if needed.
    var iconSystemName: String?
    var fullWidth: Bool
    var color: Color
    var withGradient: Bool
    var action: () -> Void
    
    init(
        text: String,
        disabled: Bool = false,
        fullWidth: Bool = true,
        iconSystemName: String? = nil,
        color: Color = .ctaSoftForest,
        withGradient: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.disabled = disabled
        self.iconSystemName = iconSystemName
        self.color = color
        self.fullWidth = fullWidth
        self.withGradient = withGradient
        self.action = action
    }
    
    var body: some View {
        ButtonBase(text: text, disabled: disabled, fullWidth: fullWidth, iconSystemName: iconSystemName, color: color, gradient: withGradient ? LinearGradient.vertical() : nil, action: action)
    }
}

struct ButtonSave_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ButtonConfirm(text: "Save Default!", action: {})
            ButtonConfirm(text: "Save Default Icon!", iconSystemName: "trash.fill", action: {})
            ButtonConfirm(text: "Save Default Gradient!", withGradient: true, action: {})
            ButtonConfirm(text: "Save Default Disabled!", disabled: true, action: {})
            ButtonConfirm(text: "Save Short!", fullWidth: false, action: {})
            ButtonConfirm(text: "Save Short Icon!", fullWidth: false, iconSystemName: "trash.fill", action: {})
            ButtonConfirm(text: "Save Short Gradient!", fullWidth: false, withGradient: true, action: {})
            ButtonConfirm(text: "Save Short Disabled!", disabled: true, fullWidth: false, action: {})
        }.padding()
    }
}
