//
//  WebNavigationLink.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-12-01.
//
import Foundation
import SwiftUI


/// Custom Navigation LInk which leads to web  view
struct WebNavigationLink<Content: View>: View {
    
    var url: String
    var content: Content
    
    /// No icon
    init(
        url: String,
        @ViewBuilder content: () -> Content
    ) {
        self.url = url
        self.content = content()
    }
    
    var body: some View {
        if let url =  URL(string: url) {
            if #available(iOS 15.0, *) {
                Link(destination: url) {
                    self.content
                }
            } else {
                Button {
                    UIApplication.shared.open(url)
                } label: {
                    self.content
                }
                // TODO: Add accessibility id for web link. + add underline if the `content` is TextView?
            }
        }
    }
}


struct WebNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.white.ignoresSafeArea(.all)
            VStack(alignment: .center, spacing: 32) {
                
                WebNavigationLink(url: LomiWebLink.warranty.rawValue) {
                    RightArrowCell(text: "systemIcon", iconSystemName: "house.fill")
                }
                WebNavigationLink(url: LomiWebLink.warranty.rawValue) {
                    Text("WebPage")
                }
            }
        }
    }
}
