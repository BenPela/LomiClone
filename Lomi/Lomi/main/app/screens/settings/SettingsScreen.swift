//
//  SettingsScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-08.
//

import SwiftUI

// The main settings screen for the Lomi app.
struct SettingsScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @State var showingProgress: Bool = false
    @State var showingLogoutConfirmation: Bool = false
    @Environment(\.presentationMode) var presentationMode
    // FIXME: This is for iot-prototype. Comment out when your merge into the develop branch
//    @EnvironmentObject private var navigationController: NavigationController

    var body: some View {
        
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 16)
                    .padding(.horizontal)
                
                VStack(spacing: 8) {
                    ButtonConfirm(text: "Create account", color: .primaryIndigoGreen, action: {
                        try? environment.logout(to: .signUp)
                    })
                    
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                        Button(action: {
                            try? environment.logout(to: .login)
                        }) {
                            Text("Log in")
                                .fontWeight(.semibold)
                        }
                    }
                        
                }.foregroundColor(.primaryIndigoGreen)
                .padding([.bottom, .leading, .trailing], 32)
                .padding([.top], 16)
                .display(environment.localStorage.isTempUser)
                
                Group {
                    // view builder closures can return a maximum of 10 elements. This is why wrapping as group.
                    let firstLomiId = environment.registrations.first?.id ?? ""
                    Group {
                        NavigationLink {
                            DeviceRegistrationScreen(initiallySelectedRegistrationId: firstLomiId)
                        } label: {
                            RightArrowCell(text: "My Lomi", iconAssetName: "lomiIcon")
                        }.disabled(environment.localStorage.isTempUser)

                        Divider()
                        
                        NavigationLink {
                            UserDetailsScreen()
                                .navigationTitle("Account details")
                        } label: {
                            RightArrowCell(text: "Account details", iconSystemName: "person.fill")
                        }.disabled(environment.localStorage.isTempUser)
                    }
                    .opacity(environment.localStorage.isTempUser ? 0.4 : 1)

                    Divider()
                    
                    WebNavigationLink(url: LomiWebLink.support.rawValue) {
                        RightArrowCell(text: "Support", iconSystemName: "exclamationmark.bubble.fill")
                    }
                    
                    Divider()
                    
                    WebNavigationLink(url: LomiWebLink.privacyPolicy.rawValue) {
                        RightArrowCell(text: "Privacy policy", iconSystemName: "lock.fill")
                    }
                                        
                    Divider()
                    
                    WebNavigationLink(url: LomiWebLink.termsConditions.rawValue) {
                        RightArrowCell(text: "Terms & conditions", iconSystemName: "doc.plaintext.fill")
                    }
                    
                    Divider()
                    
                    Button(action: { showingLogoutConfirmation = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up.fill")
                                .rotationEffect(.degrees(90))
                                .foregroundColor(.primaryIndigoGreen)
                            Text("Log out")
                            Spacer()
                        }
                    }
                    .padding()
                    .display(!environment.localStorage.isTempUser)
                    .accessibilityIdentifier("LOGOUT_BUTTON")
                }
                
                // FIXME: This is a button which leads to iot-prototype demo.
//                #if DEBUG
//                NavigationLink {
//                    IoTHomeScreen()
//                    // This is for `popToRoot`. Register this screen as a root
//                    .id(navigationController.rootViewId)
//                } label: {
//                    Label {
//                        Text("IoT Demo")
//                    } icon: {
//                        Image(systemName: "hifispeaker.and.homepodmini.fill")
//                    }.padding()
//                }
//                .accentColor(.blue)
//                .navigationTitle("Device Connection")
//                #endif
                
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarTitle("Settings", displayMode: .inline)
            .accentColor(.black)
            .padding(.top)
            .alert(isPresented: $showingLogoutConfirmation) {
                Alert(
                    title: Text("Logout.AlertTitle".localized()),
                    message: Text("Logout.AlertText".localized()),
                    primaryButton: .destructive(Text("Logout.AlertYes".localized())) {
                        showingLogoutConfirmation = false
                        showingProgress = true
                        do {
                            try environment.logout()
                            AnalyticsLogger.singleton.logEvent(.logout)
                        } catch {
                            environment.handleError(error: "Logout.ErrorText".localized())
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            
            ProgressModal(showing: showingProgress)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("SETTINGS_SCREEN")
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .environmentObject(PreviewAppEnvironmentBuilder().build())
        
        SettingsScreen(showingLogoutConfirmation: true)
            .environmentObject(PreviewAppEnvironmentBuilder().build())
        
        SettingsScreen()
            .environmentObject(PreviewAppEnvironmentBuilder().withTempUser(true).build())
    }
}
