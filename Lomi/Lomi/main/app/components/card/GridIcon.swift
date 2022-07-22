//
//  GridIconButton.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-25.
//

import SwiftUI

// A home screen grid icon
struct GridIcon: View {
    
    var text: String
    var isBold: Bool = true;
    var imageSystemName: String?
    var imageName: String?
    var withGradient: Bool = true;
    
    private let aspectRatio: CGFloat = 16/13
    /// image width : icon width
    private let imageScale: CGFloat = 65/160
    private let iconRadius: CGFloat = 16
    /// padding :  icon width
    private let paddingScale: CGFloat = 20/160
    
    var body: some View {
        
        // Get image from SF Symbol or Assets
        let imageView: Image? = {
            if let imageSystemName = imageSystemName {
                return Image(systemName: imageSystemName)
            } else if let imageName = imageName {
                return Image(imageName)
            }
            return nil
        } ()
        
        
        
        Group {
            GeometryReader { geometry in
                let iconWidth = geometry.size.width
                let drawImage = {
                    return imageView?
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: iconWidth*imageScale, alignment: .center)
                }()
                
                VStack {
                    // Some SVGs don't draw well with the gradient mask and may have their own gradient baked in.
                    // So we shouldn't always have to mask an image with a gradient
                    if (withGradient) {
                        LinearGradient.vertical()
                            .mask(drawImage)
                            .frame(maxWidth: iconWidth*imageScale, alignment: .center)
                    } else {
                        drawImage
                    }
                    
                    Text(text)
                        .font(.system(size: 14))
                        .fontWeight(isBold ? .semibold : .regular)
                        .foregroundColor(.primaryIndigoGreen)
                }
                .padding(.all, iconWidth*paddingScale)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .aspectRatio(aspectRatio, contentMode: .fit)
        .background(Color.primaryWhite)
        .cornerRadius(iconRadius)
        .shadow(color: Color.dropShadowBlack.opacity(0.35), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: iconRadius)
                .stroke(Color.primaryIndigoGreen, lineWidth: 2)
        )        
    }
}

struct GridIconButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack(alignment: .center, spacing: 20) {
                GridIcon(text: "Preview Button", isBold: false, imageSystemName: "doc.text.fill")
                GridIcon(text: "Preview \n Button", imageSystemName: "doc.text")
            }
            HStack(alignment: .center, spacing: 20) {
                GridIcon(text: "Preview Button", imageSystemName: "doc.text.fill")
                GridIcon(text: "Preview \n Button", imageSystemName: "doc.text")
            }
            HStack(alignment: .center, spacing: 20) {
                GridIcon(text: "Preview Button", imageName: "materialsIcon", withGradient: false)
                GridIcon(text: "Preview Button", imageName: "faqIcon", withGradient: false)
            }
        }
    }
}
