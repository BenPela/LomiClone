//
//  RootView.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-01.
//

import SwiftUI

// The root view of the Lomi application, which handles global errors and main tab bar navigation.
struct RootView: View {
    private static let hasLaunchedKey: String = "lomi.hasLaunched"
    
    @EnvironmentObject var environment: AppEnvironment
    
    @State private var appInited: Bool = false
    @State private var showingEntry: Bool = false
    @State private var showingProgress: Bool = true
    @State private var showingUnauthorized: Bool = false
    @State private var showingError: Bool = false
    @State private var error: String = ""
    @State private var entryScreenMode: EntryScreenMode = .firstLaunch
    
    // FIXME: This is for iot prototype. Comment out this when you merge into develop
    @StateObject private var navigationControllerForSettingsScreen = NavigationController()
    
    func appInit(auth: LomiApiAuth) {
        showingProgress = true
        let authToken = auth.authToken
        environment.lomiApi.getAppInit(
            authToken: authToken,
            request: GetAppInitRequest(userId: auth.user.id),
            onSuccess: {
                (response: GetAppInitResponse?) -> Void in
                if let response = response {
                    do {
                        if let user = response.user {
                            let newAuth = LomiApiAuth(user: user, authToken: authToken)
                            try environment.setLomiApiAuth(auth: newAuth)
                            environment.localStorage.isTempUser = false
                            if newAuth.isOnboardingComplete() {
                                environment.registrations = response.registrations
                                environment.recentTipSummaries = response.recentTipSummaries
                                appInited = true
                                showingEntry = false
                            } else {
                                entryScreenMode = .onboardingIncomplete
                                showingEntry = true
                            }
                            showingProgress = false
                        } else {
                            environment.handleError(error: "ApiError.EmptyBody".localized())
                        }
                    } catch {
                        environment.handleError(error: "AuthError.Persist".localized())
                    }
                } else {
                    showingProgress = false
                    environment.handleError(error: "ApiError.EmptyBody".localized())
                }
            },
            onError:{ (apiError: LomiApiErrorResponse) -> Void in
                showingProgress = false
                environment.handleApiErrorResponse(apiError: apiError)
            }

        )
    }
    
    private func appTempInit() {
        environment.localStorage.isTempUser = true
        if environment.recentTipSummaries.count > 0 {
            appInited = true
            showingProgress = false
        } else {
            showingProgress = true
            let tipsService = environment.serviceLocator.resolveService(TipsService.self)
            // FIXME: refactor appInit process with new dependency injection
            Task {
                let response = await tipsService?.getTips()
                appInited = true
                showingProgress = false
                if let tips = response {
                    environment.recentTipSummaries = tips
                } else {
                    environment.handleError(error: "ApiError.EmptyBody".localized())
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            if !showingEntry && appInited {
                TabView() {
                    NavigationView {
                        HomeScreen()
                            .onAppear {
                                AnalyticsLogger.singleton.logEvent(
                                    .screenView,
                                    parameters: [.screenName: AnalyticsScreenName.home]
                                )
                            }
                    }
                    .tabItem{
                        Label("Home", systemImage: "house.fill")
                    }
                    .accentColor(.primarySoftBlack)
                    .navigationViewStyle(StackNavigationViewStyle()) // https://stackoverflow.com/questions/63740788/swiftui-displaymodebuttonitem-is-internally-managed
                    
                    NavigationView {
                        TipsScreen()
                            .onAppear {
                                AnalyticsLogger.singleton.logEvent(
                                    .screenView,
                                    parameters: [.screenName: AnalyticsScreenName.tips]
                                )
                            }
                    }
                    .tabItem{
                        Label("Reading", systemImage: "book.fill")
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    
                    NavigationView {
                        SettingsScreen()
                            .onAppear {
                                AnalyticsLogger.singleton.logEvent(
                                    .screenView,
                                    parameters: [.screenName: AnalyticsScreenName.settings]
                                )
                            }
                    }
                    // FIXME: This is for iot prototype. Comment out this when you merge into develop
                    .environmentObject(navigationControllerForSettingsScreen)
                    .tabItem{
                        Label("Settings", systemImage: "gear")
                            .accessibilityIdentifier("SETTINGS_TAB_BUTTON")
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                }
                .disabled(showingProgress)
                .accentColor(Color.primaryIndigoGreen)
            }
            
            if showingEntry {
                // TODO: Fix alert hierarchy
                // If the alert is in the same view hierarchy, it won't show up. Because we're using common alert in root view, we have to create another nav view.
                NavigationView {
                    EntryScreen(
                        mode: entryScreenMode,
                        onSignedIn: {
                            (auth: LomiApiAuth) -> Void in
                            showingEntry = false
                            appInit(auth: auth)
                        },
                        onTempSignedIn: {
                            showingEntry = false
                            appTempInit()
                        }
                    )
                        .navigationBarHidden(true)
                        .navigationBarTitleDisplayMode(.inline)
                }
                
            }
            
            ProgressModal(showing: showingProgress)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut)
                .transition(.opacity)
        }
        .onAppear(perform: {
            
            // Initialize the globalState handlers
            environment.handleUnauthorized = {
                () -> Void in
                appInited = false // TODO: consider globalStateValid
                entryScreenMode = .unauthorized
                showingEntry = true
            }
            environment.handleLogout = { screen in
                appInited = false
                entryScreenMode = .loggedOut(to: screen)
                showingEntry = true
            }
            environment.showError = {
                (errorToShow: String) -> Void in
                error = errorToShow
                withAnimation {
                    showingError = true
                }
            }
            do {
                if !appInited {
                    if environment.localStorage.isTempUser {
                        appTempInit()
                    } else if let auth = try environment.getLomiApiAuth() {
                        appInit(auth: auth)
                    } else {
                        if environment.localStorage.hasLaunched {
                            entryScreenMode = .loggedOut(to: .login)
                        } else {
                            entryScreenMode = .firstLaunch
                            environment.localStorage.hasLaunched = true
                        }
                        
                        showingProgress = false
                        showingEntry = true
                    }
                }
            } catch {
                // TODO: consider showing onboarding in an "auth storage error" mode?
                showingProgress = false
                environment.handleError(error: "AuthError.Persist".localized())
            }
        })
        .alert(isPresented: $showingError, content: {
            Alert(
                title: Text("DefaultError.AlertTitle".localized()),
                message: Text(error),
                dismissButton: .default(Text("Ok".localized())))
        })
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(
                PreviewAppEnvironmentBuilder()
                    .build())
        
        RootView()
            .environmentObject(
                PreviewAppEnvironmentBuilder()
                    .withTempUser(true)
                    .withRegistrations(registrations: [])
                    .build())
        
    }
}
