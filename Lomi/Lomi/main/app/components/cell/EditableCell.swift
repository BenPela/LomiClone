//
//  EditableCell.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-10.
//

import Foundation
import SwiftUI

/// A cell view which has edit link, like "[ text             edit ]". This view has to be in the Navigation view hierarchy
struct EditableCell<Content: View>: View {
    
    let content: Content
    
    var label: String
    var text: String
    var editLabel: String
    
    init(
        @ViewBuilder destination: () -> Content,
        label:String,
        text: String,
        editLabel: String = "Edit"
    ) {
        self.content = destination()
        self.label = label
        self.text = text
        self.editLabel = editLabel
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            HStack {
                Text(text)
                Spacer()
                NavigationLink(
                    destination: content,
                    label: {
                        Text(editLabel)
                            .foregroundColor(.textDarkGrey)
                            .font(.system(size: 14))
                            .underline()
                        // TODO: This can be Link or web link depends on the `content` type. Add accessibilityId based on the `content` type.
                    }
                )
            }
        }
        .padding()
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .leading
        )
        
    }
}


struct EditableCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.white.ignoresSafeArea(.all)
            NavigationView {
                EditableCell(destination: {
                    Text("Destination")
                }, label: "label", text: "text")
            }
        }
    }
}


