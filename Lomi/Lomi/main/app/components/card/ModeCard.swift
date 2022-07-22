//
//  ModeCard.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-19.
//

import SwiftUI

// A screen that presents information regarding a single Lomi mode.
struct ModeCard: View {
    var mode: Mode
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            // Overview
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 8) {
                    Text("\(mode.title)")
                        .fontWeight(.semibold)
                        .font(.title3)
                        .foregroundColor(.primaryIndigoGreen)
                        .padding(.trailing, 8)
                    
                    Image(systemName: "clock.arrow.circlepath")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.textGreyInactive)
                        .frame(width: 14, height: 14, alignment: .center)
                    Text("\(mode.time) hours")
                        .foregroundColor(.textGreyInactive)
                        .font(.system(size: 12))
                    Spacer()
                }
                HStack(alignment: .top, spacing: 16) {
                    Image(mode.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48, alignment: .center)
                    Text(mode.description)
                        .font(.callout)
                        .foregroundColor(.primarySoftBlack)
                        .lineSpacing(4)
                    Spacer()
                }
            }
            
            VStack{
                ForEach(mode.sections, id: \.hashValue) { section in
                    CollapsibleSection {
                        Text(section.header)
                            .foregroundColor(.primarySoftBlack)
                            .font(.headline)
                    } content: {
                        Text(section.body)
                            .foregroundColor(.primarySoftBlack)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(6)
                    }

                }
            }
        }
    }
}

struct ModeCardView_Previews: PreviewProvider {
    static var previews: some View {
        ModeCard(mode: Mode.modes[0])
    }
}
