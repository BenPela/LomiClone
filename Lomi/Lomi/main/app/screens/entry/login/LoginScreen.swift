//
//  LoginView.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-17.
//

import SwiftUI

enum LoginScreenMode {
    case newUser, unauthorized
}

// A screen that allows the user to login to their existing Lomi user account.
struct LoginScreen: View {
    typealias Strings = LoginStrings

    @EnvironmentObject var environment: AppEnvironment
    var mode: LoginScreenMode
    var onSignup: () -> Void
    var onSignedIn: (_: LomiApiAuth) -> Void
    
    @StateObject var viewModel: LogInViewController
    @State private var contentHeight: CGFloat = 240
    private var imageHeight: CGFloat {
        UIScreen.main.bounds.size.height-contentHeight-64
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Image(Strings.sourcePath.imageLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom)
                        .frame(maxHeight: imageHeight)
                        .accessibilityHidden(true)
                    
                    VStack {
                        header
                        content
                        buttonContinue
                    }
                    .background(
                        // This will calculate the size of contents (except image) after those are render.
                        GeometryReader { geometryProxy in
                            Color.clear
                                .onAppear {
                                    contentHeight = geometryProxy.size.height
                                }
                        }
                    )
                }
                .padding()
                .onAppear(perform: {
                    if mode == .unauthorized {
                        viewModel.alertType = .unauthorized
                    }
                    AnalyticsLogger.singleton.logEvent(
                        .screenView,
                        parameters: [.screenName: AnalyticsScreenName.login]
                    )
                })
                .alert(item: $viewModel.alertType) { type in
                    switch type {
                    case .unauthorized:
                        return alertUnauthorized
                    case .resendEmailVerificationConfirm:
                        return alertResendConfirm
                    }
                }
            }
            ProgressModal(showing: viewModel.isLoading)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("LOGIN_SCREEN")
    }
}


// MARK: - Subviews
extension LoginScreen {
    
    @ViewBuilder
    var header: some View {
        HStack {
            Text(Strings.signUpPrompt)
                .foregroundColor(.primarySoftBlack)
                .fontWeight(.medium)
            
            // TODO: Encapsulate the button with a new component after we get more direction from design.
            Button(action: onSignup) {
                Text(Strings.signUpButtonLabel)
                    .foregroundColor(.ctaSoftForest)
                    .fontWeight(.medium)
                    .underline()
                    .accessibilityIdentifier("\("Sign up")_LINK_BUTTON".identifierFormat())
            }
        }
        .font(.subheadline)
        .padding(.bottom)
        
        if mode == .newUser {
            Text(Strings.loginPrompt)
                .font(.custom("CoreSansC-75ExtraBold", size: 30))
                .padding(.bottom, 32)
                .accessibilitySortPriority(1)
        }
        
        if mode == .unauthorized {
            Text(Strings.loginPromptUnauthorized)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    var content: some View {
        VStack(alignment: .center, spacing: 16) {
            InputTextField(
                field: $viewModel.email,
                inputType: .email,
                prompt: viewModel.emailPrompt
            )
            InputTextField(
                field: $viewModel.password,
                isSecure: true,
                inputType: .password,
                prompt: viewModel.passwordPrompt,
                showEyeIcon: true
            )
        }
        
        ButtonLink(
            text: Strings.resetPasswordButtonLabel,
            textSize: 13,
            textColor: .primaryIndigoGreen,
            action: {
                viewModel.showingResetPassword = true
            }
        )
            .frame(maxWidth: .infinity, alignment: .trailing)
        // TODO: Change to pop up?
            .sheet(isPresented: $viewModel.showingResetPassword, content: {
                ResetPasswordScreen(onComplete: {
                    () -> Void in
                    viewModel.showingResetPassword = false
                })
            })
            .padding(.bottom, 24)
            .padding(.top, 4)
    }
    
    
    @ViewBuilder
    var buttonContinue: some View {
        ButtonConfirm(text: Strings.loginButtonLabel, disabled: !viewModel.isAllValid() || viewModel.isLoading, action: {
            viewModel.isLoading = true
            environment.lomiApi.authenticate(
                request: AuthenticateRequest(email: viewModel.email, password: viewModel.password ),
                onSuccess: {
                    (response: AuthenticateResponse?) -> Void in
                    viewModel.isLoading = false
                    if let response = response {
                        onSignedIn(LomiApiAuth(user: response.user, authToken: response.authToken))
                        AnalyticsLogger.singleton.logEvent(.login)
                    } else {
                        environment.handleError(error: "ApiError.EmptyBody".localized())
                    }
                },
                onError: {
                    (apiError: LomiApiErrorResponse) -> Void in
                    viewModel.isLoading = false
                    if !apiError.isUnauthorized() && apiError.isUnverified() {
                        viewModel.alertType = .resendEmailVerificationConfirm
                    } else {
                        environment.handleApiErrorResponse(apiError: apiError, isAuthAttempt: true)
                    }
                }
            )
            
        })
            .padding(.bottom, 16)
    }
    
    var alertUnauthorized: Alert {
        Alert(
            title: Text(Strings.alert.loginUnauthorizedTitle),
            message: Text(Strings.alert.loginUnauthorizedMessage),
            dismissButton: .default(Text(Strings.alert.loginUnauthorizedConfirm))
        )
    }
    
    var alertResendConfirm: Alert {
        Alert(
            title: Text(Strings.alert.resendEmailTitle),
            message: Text(Strings.alert.resendEmailMessage(email: viewModel.email)),
            primaryButton: .default(Text(Strings.alert.resendEmailConfirm))
            {
                viewModel.isLoading = true
                environment.lomiApi.resendEmailVerification(
                    request: ResendEmailVerificationRequest(email: viewModel.email),
                    onSuccess: { _ in
                        // TODO: Add analytics to resend email if exist.
                        viewModel.isLoading = false
                    },
                    onError: { (apiError: LomiApiErrorResponse) -> Void in
                        viewModel.isLoading = false
                        environment.handleApiErrorResponse(apiError: apiError)
                    }
                )
            },
            secondaryButton: .cancel()
        )
    }
}


// MARK: - Previews
struct LoginScreen_Previews: PreviewProvider {
    
    static let viewModelWithResendConfirm: LogInViewController = {
        let vm = LogInViewController()
        vm.alertType = .resendEmailVerificationConfirm
        vm.email = "preview@email.com"
        return vm
    } ()
    
    static let viewModelWithLoading: LogInViewController = {
        let vm = LogInViewController()
        vm.isLoading = true
        return vm
    } ()
    
    static var previews: some View {
        
        // Small device (for checking image size)
        LoginScreen(
            mode: .newUser,
            onSignup: { },
            onSignedIn: { _ in },
            viewModel: LogInViewController()
        )
            .previewDevice("iPhone SE (1st generation)")
            .environmentObject(PreviewAppEnvironmentBuilder().build())
        
        // Large device
        LoginScreen(
            mode: .newUser,
            onSignup: { },
            onSignedIn: { _ in },
            viewModel: LogInViewController()
        )
            .previewDevice("iPhone 13 Pro Max")
            .environmentObject(PreviewAppEnvironmentBuilder().build())
        
        // Unauthorized user
        LoginScreen(
            mode: .unauthorized,
            onSignup: { },
            onSignedIn: { _ in },
            viewModel: LogInViewController()
        )
            .environmentObject(PreviewAppEnvironmentBuilder().build())
        
        // Unverified user
        LoginScreen(
            mode: .newUser,
            onSignup: { },
            onSignedIn: { _ in },
            viewModel: viewModelWithResendConfirm
        )
            .environmentObject(PreviewAppEnvironmentBuilder().build())
        
        // Loading
        LoginScreen(
            mode: .newUser,
            onSignup: { },
            onSignedIn: { _ in },
            viewModel: viewModelWithLoading
        )
            .previewDevice("iPhone 13")
            .environmentObject(PreviewAppEnvironmentBuilder().build())
    }
}
