//
//  ContentView.swift
//  Lomi
//
//  Created by Chris Worman on 2021-07-07.
//

import SwiftUI

// The home screen of the app, which provides quick access to commonly used application features.
struct HomeScreen: View {

    @EnvironmentObject var environment: AppEnvironment
    @State var showingTip: Bool = false
    @State var selectedRegistrationId: String = ""
    var navigationItemsLayout: [GridItem] = Array(repeating: .init(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        let getName: String = {
            var name = ""
            
            if !environment.localStorage.isTempUser,
               let firstName = environment.currentUser?.firstName
            {
                name = " \(firstName)"
            }
            
            return "Hey\(name),\nlet’s make some dirt!"
        }()
        
        ScrollView {
            VStack(alignment: .leading) {

                Text(getName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 24)
                    .lineSpacing(8)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.black)
                    .padding(.bottom, 20)

                Text("My Lomi")
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .center, spacing: 16) {
                        Group {
                            ForEach(environment.registrations) { registration in
                                NavigationLink(
                                    destination: DeviceRegistrationScreen(initiallySelectedRegistrationId: registration.id)
                                ) {
                                    DeviceIcon(text: registration.lomiName)
                                }
                            }
                        }.display(environment.registrations.count > 0)
                        
                        NavigationLink(
                            destination: AddDeviceScreen(
                                viewController: AddDeviceViewController(device: Device()),
                                selectedRegistrationId: $selectedRegistrationId
                            )
                        ) {
                            DeviceIcon(isAddButton: true, maxSize: 48)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("No Lomi registered")
                                .foregroundColor(.textDarkGrey)
                                .fontWeight(.semibold)
                                .font(.system(size: 14))
                            
                            Text("Add a Lomi, and find it here!")
                                .foregroundColor(.gray)
                                .fontWeight(.semibold)
                                .font(.system(size: 14))
                        }.display(environment.registrations.count == 0)
                    }
                    .frame(height: 80, alignment: .center)
                    // This is for avoid clipping shadows and boarders
                    .padding(EdgeInsets.init(top: 4, leading: 2, bottom: 2, trailing: 16))
                }.display(!environment.localStorage.isTempUser)
                
                HStack{
                    DeviceIcon(isAddButton: true, isDisabled: true, maxSize: 54)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Add your Lomi to register for your warranty.")
                            .font(.caption)
                            
                        HStack(spacing: 4) {
                            Text("First, you'll need to")
                                .fontWeight(.semibold)
                            Button(action: {
                                try? environment.logout(to: .signUp)
                            }){
                                Text("create an account.")
                                    .fontWeight(.bold)
                                    .overlay(RoundedRectangle(cornerRadius: 2).frame(height: 2).offset(y: 4) .foregroundColor(.gold), alignment: .bottom)
                            }
                            
                            
                        }.font(.subheadline)
                            
                    }.foregroundColor(.white)
                        

                        
                        
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding([.top, .bottom])
                .background(
                    LinearGradient.diagonal(direction: (VerticalDirection.TopToBottom, HorizontalDirection.LeftToRight))
                        .ignoresSafeArea(.container).frame(width: 1000)
                )
                .display(environment.localStorage.isTempUser)

                Text("Lomi Guide")
                    .fontWeight(.semibold)
                    .padding(.top)
                    .padding(.bottom, 5)

                LazyVGrid(columns: navigationItemsLayout, spacing: 20) {
                    // TODO: Create data of array and user for each
                    NavigationLink(destination: ControlsScreen() ) {
                        GridIcon(text: "One button", imageName: "controlsIcon", withGradient: false)
                    }
                    NavigationLink(destination: ModesScreen(modes: Mode.modes)
                                    .navigationTitle("Modes")) {
                        GridIcon(text: "Modes", imageSystemName: "leaf.arrow.circlepath")
                    }
                    NavigationLink(destination: MaterialsScreen()) {
                        GridIcon(text: "Do's & Don'ts", imageName: "materialsIcon", withGradient: false)
                    }
                    WebNavigationLink(url: LomiWebLink.support.rawValue) {
                        GridIcon(text: "FAQ", imageName: "faqIcon", withGradient: false)
                    }
                }
                .padding(.bottom, 36)

                if environment.recentTipSummaries.count > 0 {
                    
                    Text("Recommended Reading")
                        .fontWeight(.semibold)
                        .padding(.bottom, 18)
                    ScrollView(.horizontal) {
                        HStack(alignment: .center, spacing: 18) {
                            ForEach(environment.recentTipSummaries) { tip in
                                NavigationLink {
                                    TipScreen(tipId: tip.id)
                                } label: {
                                    ZStack {
                                        // TODO: Create another component
                                        RemoteImage(url: tip.image.url, contentMode: .fill, aspectRatio: 188/150)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                            .overlay(
                                                LinearGradient(gradient: Gradient(colors: [.clear, .clear, .dropShadowBlack]), startPoint: UnitPoint.init(x: 0.5, y: 0.2), endPoint: .bottom)
                                            )
                                            .overlay(
                                                Text(tip.title)
                                                    .foregroundColor(.primaryWhite)
                                                    .font(.system(size: 13))
                                                    .fontWeight(.medium)
                                                    .padding(.horizontal, 14)
                                                    .padding(.bottom, 9)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading),
                                                alignment: .bottomLeading
                                            )
                                            .cornerRadius(16)
                                            .background(Color.primaryWhite)
                                    }
                                }

                            }
                        }.frame(height: 160, alignment: .center)
                    }
                }
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding()
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("HOME_SCREEN")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        NavigationView {
            HomeScreen().environmentObject(PreviewAppEnvironmentBuilder().build())
        }
        
        NavigationView {
            HomeScreen().environmentObject(PreviewAppEnvironmentBuilder().withRegistrations(registrations: []).build())
        }
        
        
        NavigationView {
            HomeScreen().environmentObject(PreviewAppEnvironmentBuilder().withTempUser(true).withRegistrations(registrations: []).build())
        }

    }
}
