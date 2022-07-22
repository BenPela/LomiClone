//
//  CollapsibleSection.swift
//  CollapsibleSection
//
//  Created by Takayuki Yamaguchi on 2022-01-10.
//

import SwiftUI

struct CollapsibleSection<Header: View, Content: View>: View {
    private var header: () -> Header
    private var content: () -> Content
    
    @State private var isCollapsed = false
    
    init(
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Rectangle()
                .fill(.black)
                .frame(height: 1)
            
            HStack(alignment: .center, spacing: 0) {
                header()
                Spacer()
                Image(systemName: isCollapsed ? "minus" : "plus")
                    .foregroundColor(.primarySoftBlack)
                    .font(.headline)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isCollapsed.toggle()
                }
            }

            content()
                .padding(.bottom, 16)
                .display(isCollapsed)
        }
        .padding(.bottom, 16)
    }
}


// MARK: - Previews

struct CollapsableSection_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CollapsibleSection {
                Text("What does Eco Express Mode do?")
                    .foregroundColor(.primarySoftBlack)
                    .font(.headline)
            } content: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sometimes you just want to get rid of your food waste quickly. Eco Express mode will break it down in 3-5 hours. This mode is for food waste and is the best option for those wanting the fastest results and low energy consumption. ")
                        .foregroundColor(.primarySoftBlack)
                        .font(.body)
                }
            }
            CollapsibleSection {
                Text("On/standby")
                    .foregroundColor(.primarySoftBlack)
                    .font(.headline)
            } content: {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Spacer()
                        Image(systemName: "square.and.arrow.up.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                        Spacer()
                    }.padding()
                    Text("When plugged in, Lomi will beep and all lights will flash green. When in standby, lights will turn off. Lomi’s ready to start a cycle when you are!")
                        .foregroundColor(.primarySoftBlack)
                        .font(.body)
                }
            }
        }.padding()

    }
}
