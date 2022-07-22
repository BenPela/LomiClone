//
//  SupportButton.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-08.
//

import Foundation
import SwiftUI

/// A button without background color. This is used for supplement or support. eg,  "re-send email" , "see more details"
struct ButtonLink: View {
    
    var text: String
    var textSize:  CGFloat
    var action: () -> Void
    /// Default: .textDarkGrey
    var textColor: Color
    
    init(
        text: String,
        textSize:CGFloat = 16,
        textColor: Color = .textDarkGrey,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.textSize = textSize
        self.textColor = textColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action){
            Text(text)
                .foregroundColor(textColor)
                .font(.system(size: textSize))
                .font(.body)
                .underline(true)
                .accessibilityIdentifier("\(text)_LINK_BUTTON".identifierFormat())
        }
        .buttonStyle(.plain)
        
    }
}

struct SupportButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            VStack{
                ButtonLink(text: "Button Text", action:{})
            }
            .padding()
        }.background(Color.primaryWhite)
    }
}
