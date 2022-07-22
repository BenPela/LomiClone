//
//  ButtonDelete.swift
//  Lomi
//
//  Created by Calham Northway on 2022-01-28.
//

import SwiftUI

struct ButtonDelete: View {
    
    var text: String
    var action: () -> Void
    var disabled: Bool
    /// Display icon on left side if needed.
    var iconSystemName: String?
    var fullWidth: Bool
    
    init(
        text: String,
        action: @escaping () -> Void,
        disabled: Bool = false,
        fullWidth: Bool = true,
        iconSystemName: String? = nil
    ) {
        self.text = text
        self.disabled = disabled
        self.iconSystemName = iconSystemName
        self.action = action
        self.fullWidth = fullWidth
    }
    
    var body: some View {
        ButtonBase(text: text, disabled: disabled, fullWidth: fullWidth, iconSystemName: iconSystemName, color: .alert, action: action)
    }
}

struct ButtonDelete_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ButtonDelete(text: "Delete Default!", action: {})
            ButtonDelete(text: "Delete Default Icon!", action: {}, iconSystemName: "trash.fill")
            ButtonDelete(text: "Delete Default Disabled!", action: {}, disabled: true)
            ButtonDelete(text: "Delete Short!", action: {}, fullWidth: false)
            ButtonDelete(text: "Delete Short Icon!", action: {}, fullWidth: false, iconSystemName: "trash.fill")
            ButtonDelete(text: "Delete Short Disabled!", action: {}, disabled: true, fullWidth: false)
        }.padding()
    }
}
