//
//  ControlsScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-07.
//

import SwiftUI

// A screen that presents the Lomi "Controls", which is a brief overview of the Lomi appliance operations.
struct ControlsScreen: View {
    
    private var imageHeight: CGFloat {
        let wideImageRatio: CGFloat = 2.0 // Align all images to wide-image's height
        let verticalPadding: CGFloat = 40
        let minHeight: CGFloat = 40
        return max(minHeight, (UIScreen.main.bounds.width - verticalPadding*2)/wideImageRatio)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 18) {
                    Text("One button")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("Turn your waste into dirt with the push of a button!")
                        .font(.callout)
                        .fontWeight(.medium)
                        .lineSpacing(8)
                }   
                .padding(.bottom, 28)
                
                VStack(alignment: .leading) {
                    Text("Operation")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding([.bottom], 10)
                    

                    ForEach(ControlState.controls) { control in
                        CollapsibleSection {
                            Text(control.title)
                                .foregroundColor(.textDarkGrey)
                                .font(.headline)
                                .fontWeight(.bold)
                        } content: {
                            VStack(alignment: .center, spacing: 32) {
                                Image(control.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: imageHeight)
                                Text(control.description)
                                    .foregroundColor(.textDarkGrey)
                                    .font(.callout)
                                    .lineSpacing(6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    Text("Troubleshooting")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding([.top], 16)
                        .padding([.bottom], 10)

                    ForEach(ControlState.troubleshooting) { control in
                        CollapsibleSection {
                            Text(control.title)
                                .foregroundColor(.textDarkGrey)
                                .font(.headline)
                                .fontWeight(.bold)
                        } content: {
                            VStack(alignment: .center, spacing: 32) {
                                Image(control.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: imageHeight)
                                Text(control.description)
                                    .foregroundColor(.textDarkGrey)
                                    .font(.callout)
                                    .lineSpacing(6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }

                WebNavigationLink(url: LomiWebLink.support.rawValue) {
                    Text("Still have questions?")
                        .underline()
                        .accentColor(Color.dropShadowBlack)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.bottom, 32)
            }
            .padding()
        }
        .navigationTitle("One button")
        .onAppear(perform: {
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.oneButton]
            )
        })
    }
}

struct ControlsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ControlsScreen()
    }
}
