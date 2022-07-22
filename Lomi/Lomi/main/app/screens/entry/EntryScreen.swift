//
//  EntryScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-09.
//

import SwiftUI

enum EntryScreenMode: Equatable {
    case
    firstLaunch,
    unauthorized,
    onboardingIncomplete,
    loggedOut(to: EntryScreen.CurrentScreen?)
}

// A composite screen that shows a series of "entry" screens, which allow the user to
// sign-up for a new Lomi user account or login to an existing user account.  The starting screen
// and behaviour is determined by the "mode".
struct EntryScreen: View {
    
    @EnvironmentObject var environment: AppEnvironment
    var mode: EntryScreenMode
    var onSignedIn: (_: LomiApiAuth) -> Void
    var onTempSignedIn: () -> Void
    @State var resendEmailAlertShowing = false
    @State var currentScreen: CurrentScreen = .empty

    // FIXME: signUpViewModel should belong to SignUpScreen, but is instantiated here to support the old dependency of ConfirmEmailScreen
    private let signUpViewModel = SignUpViewModel()
    
    var body: some View {
        content
            .onAppear {
                switch mode {
                case .firstLaunch:
                    currentScreen = .welcome
                case .onboardingIncomplete:
                    currentScreen = .onboardingRegister
                case .unauthorized:
                    currentScreen = .login
                case let .loggedOut(screen):
                    DispatchQueue.main.async {
                        withAnimation {
                            switch screen {
                            case .signUp:
                                currentScreen = .signUp
                            case .welcome:
                                currentScreen = .welcome
                            default:
                                currentScreen = .login
                            }
                        }
                    }
                }
            }
    }
}

extension EntryScreen {
    enum CurrentScreen: Equatable {
        case empty, welcome, signUp,  confirmEmail, login, onboardingRegister, onboardingVideo
    }
    
    var content: some View {
        ZStack {
            switch currentScreen {
            case .welcome:
                WelcomeScreen(onComplete: {
                    withAnimation {
                        currentScreen = .signUp
                    }
                }, onLogin: {
                    withAnimation {
                        currentScreen = .login
                    }
                })
                    .transition(.move(edge: .bottom))
            case .signUp, .login:
                ZStack {
                    SignUpScreen(
                        viewModel: signUpViewModel,
                        onSuccess: {
                            withAnimation {
                                currentScreen = .confirmEmail
                            }
                        }, onLogin: {
                            withAnimation {
                                currentScreen = .login
                            }
                        }, onTempSignedIn: {
                            onTempSignedIn()
                        }
                    )
                        .opacity(currentScreen == .signUp ? 1 : 0)
                    
                    LoginScreen(
                        mode: mode == .unauthorized ? .unauthorized : .newUser,
                        onSignup: {
                            withAnimation {
                                currentScreen = .signUp
                            }
                        },
                        onSignedIn: {
                            (auth: LomiApiAuth) -> Void in
                            onSignedIn(auth)
                        },
                        viewModel: LogInViewController()
                    )
                        .opacity(currentScreen == .login ? 1 : 0)
                }
            case .confirmEmail:
                // FIXME: ConfirmEmailScreen shouldn't require signUpViewModel
                ConfirmEmailScreen(
                    onNext: {
                        withAnimation {
                            currentScreen = .login
                        }
                    },
                    onResendEmail: {
                        resendEmailAlertShowing = true
                    },
                    email: signUpViewModel.email
                )
                    .alert(isPresented: $resendEmailAlertShowing) {
                        Alert(
                            title: Text("Success!"),
                            message: Text("We’ve sent an email with a link to verify your email address."),
                            dismissButton: .default(Text("Got it!"))
                        )
                    }
                    .transition(.move(edge: .bottom))
            case .onboardingRegister:
                OnboardingRegisterScreen(
                    viewModel: AddDeviceViewController(device: Device()),
                    onNext: {
                        withAnimation {
                            currentScreen = .onboardingVideo
                        }
                    }
                )
                    .transition(.move(edge: .trailing))
            case .onboardingVideo:
                OnboardingVideoScreen(onComplete: {
                    if let auth = try? environment.getLomiApiAuth() {
                        onSignedIn(auth)
                    } else {
                        environment.handleError(error: "AuthError.NoAuth".localized())
                    }
                }).transition(.move(edge: .trailing))
            case .empty:
                EmptyView()
            }
        }
    }
}

struct EntryScreen_Previews: PreviewProvider {
    static var previews: some View {
        EntryScreen(
            mode: .firstLaunch,
            onSignedIn: {
                (auth: LomiApiAuth) -> Void in
            },
            onTempSignedIn: {})
        OnboardingVideoScreen(onComplete: {})
    }
}
