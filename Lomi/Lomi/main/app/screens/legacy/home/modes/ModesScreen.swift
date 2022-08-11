//
//  ModesScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-07.
//

import SwiftUI

// A screen that shows a brief overview of the Lomi modes.
struct ModesScreen: View {    
    @State var selectedTab: DeviceMode = .grow
    let modes: [Mode]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Modes")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Tab of modes
                HStack(alignment: .center, spacing: 8) {
                    ForEach(modes, id: \.self) { mode in
                        ModeTab(
                            selectedId: $selectedTab,
                            tabId: mode.id,
                            label: mode.title,
                            action: {
                                selectedTab = mode.id
                                AnalyticsLogger.singleton.logEvent(
                                    .screenView,
                                    parameters: [
                                        .screenName: AnalyticsScreenName.mode,
                                        .itemCategory: mode.title
                                    ]
                                )
                            }
                        )
                    }
                }.padding(.horizontal)
                
                ZStack(alignment: .top) {
                    ForEach(modes, id: \.self) { mode in
                        ModeCard(mode: mode)
                            .opacity(mode.id == selectedTab ? 1: 0)
                    }.padding(.all)
                }
            }
        }
        .padding(.top, 32)
        .navigationTitle("Modes")
        .onAppear(perform: {
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.modes]
            )
            // view the first mode by default when the screen opens
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [
                    .screenName: AnalyticsScreenName.mode,
                    .itemCategory: modes.first?.title ?? ""
                ]
            )
        })
    }
}

struct ModesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModesScreen(modes: Mode.modes)
    }
}
