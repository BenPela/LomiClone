//
//  UserCreateView.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-12.
//

import SwiftUI

// A screen that allows the user to sign-up for a new Lomi user account.
struct SignUpScreen: View {
    typealias Strings = SignupStrings
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var environment: AppEnvironment
    @StateObject var viewModel: SignUpViewModel
    var onSuccess: () -> Void
    var onLogin: () -> Void
    var onTempSignedIn: () -> Void

    var body: some View {
        // FIXME: would like to instantiate SignUpViewController in init instead of body, but it depends on @EnvironmentObject AppEnvironment, so this is here until we refactor our dependency injection
        let userService = environment.serviceLocator.resolveService(UserService.self)
        let viewController = SignUpViewController(viewModel: viewModel, userService: userService!)
        ZStack {
            ScrollView {
                VStack { // container VStack
                    VStack(alignment: .center, spacing: 32) { // header VStack
                        HStack {
                            Text(Strings.logInPrompt)
                                .foregroundColor(.primaryIndigoGreen)
                            // TODO: Encapsulate the button with a new component after we get more direction from design.
                            Button(action: {
                                onLogin()
                            }){
                                Text(Strings.logInButtonLabel)
                                    .foregroundColor(.primaryIndigoGreen)
                                    .fontWeight(.semibold)
                                    .underline()
                                    .accessibilityIdentifier("\("Log in")_LINK_BUTTON".identifierFormat())
                            }
                        }
                        
                        Image(Strings.sourcePath.imageLogo)
                            .foregroundColor(Color.primaryIndigoGreen)
                        
                        Text(Strings.logoSubtitle)
                            .foregroundColor(.primaryIndigoGreen)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 24)
                            .lineSpacing(4)
                            
                            
                    }
                    .font(.callout)
                    .padding(.leading)
                    .padding(.trailing)
                    
                    // input VStack
                    VStack(alignment: .center, spacing: 16) {
                        
                        InputTextField(
                            field: $viewModel.firstName,
                            inputType: .firstName,
                            prompt: viewModel.firstNamePrompt
                        )
                        InputTextField(
                            field: $viewModel.lastName,
                            inputType: .lastName,
                            prompt: viewModel.lastNamePrompt
                        )
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
                        InputTextField(
                            field: $viewModel.confirmationPassword,
                            isSecure: true,
                            inputType: .confirmationPassword,
                            prompt: viewModel.confirmationPasswordPrompt,
                            showEyeIcon: true
                        )
                    }

                    ButtonConfirm(text: "Continue", disabled: !viewModel.isAllValid() || viewModel.isLoading, action: {
                        viewController.createUser(
                            onSuccess: onSuccess,
                            onFailure: {
                                environment.handleError(error: "ApiError.EmptyBody".localized())
                            }
                        )
                    })
                    .padding(.top, 32)
                    .padding(.bottom, 16)
                    
                    // TODO: Encapsulate the button later
                    Button {
                        onTempSignedIn()
                    } label: {
                        Text(Strings.guestLogInButtonLabel)
                            .foregroundColor(.textDarkGrey)
                            .fontWeight(.medium)
                            .font(.subheadline)
                            .underline()
                            .accessibilityIdentifier("\("Continue as guest")_LINK_BUTTON".identifierFormat())
                    }
                    
                    // TODO: Localizable hyper link
                    VStack(alignment: .center, spacing: 4) { // footer VStack, padding should match header VStack
                        Text("By continuing, you agree to Lomi’s")
                            .foregroundColor(.textDarkGrey)
                        HStack(alignment: .center, spacing: 4) {
                            // TODO: Encapsulate the weblink later if possible
                            Link(destination: URL(string: LomiWebLink.termsConditions.rawValue)!, label: {
                                Text("Terms & Conditions")
                                    .foregroundColor(.textDarkGrey)
                                    .fontWeight(.semibold)
                                    .underline()
                            })
                            .accessibilityRemoveTraits(.isLink)
                            Text("and")
                                .foregroundColor(.textDarkGrey)
                            Link(destination: URL(string: LomiWebLink.privacyPolicy.rawValue)!, label: {
                                Text("Privacy Policy.")
                                    .foregroundColor(.textDarkGrey)
                                    .fontWeight(.semibold)
                                    .underline()
                            })
                            .accessibilityRemoveTraits(.isLink)
                        }
                    }
                    .font(.callout)
                    .padding()
                
                } // container VStack
                .padding()
            
            }  // ScrollView
            
            ProgressModal(showing: viewModel.isLoading)

        } // ZStack
        .onAppear(perform: {
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.signUp]
            )
        })
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("SIGNUP_SCREEN")
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen(
            viewModel: SignUpViewModel(),
            onSuccess: {},
            onLogin: {},
            onTempSignedIn: {}
        )
            .environmentObject(PreviewAppEnvironmentBuilder().build())
    }
}
