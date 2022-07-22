//
//  OnboardingRegisterScreen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-02-03.
//

import SwiftUI

struct OnboardingRegisterScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @StateObject var viewModel: AddDeviceViewController

    var onNext: ()->Void

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center, spacing: 32) {
                    LomiDeviceHeader()
                    LomiDeviceContent(viewModel: viewModel)
                    footer
                }.padding()
            }
            ProgressModal(showing: viewModel.isLoading)
        }
        .onAppear(perform: {
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.onboardingRegister]
            )
        })
        .alert(isPresented: $viewModel.showingSuccess, content: { successAlert })
    }
}

// MARK: - Subviews
extension OnboardingRegisterScreen {
    var footer: some View {
        VStack(alignment: .center, spacing: 50) {
            ButtonConfirm(text: "Save", disabled: !viewModel.isAllValid() || viewModel.isLoading, action: onConfirm)
            // TODO: Encapsulate the button with a new component after we get more direction from design.
            Button(action: onNext) {
                Text("I'll do this later")
                    .foregroundColor(.textGreyInactive)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .underline()
                    .accessibilityIdentifier("\("I'll do this later")_LINK_BUTTON".identifierFormat())
            }
        }
    }
    
    var successAlert: Alert {
        Alert(
            title: Text("Success"),
            message: Text("Your Lomi has been registered!"),
            dismissButton: Alert.Button.default(
                Text("Ok"), action: onNext
            )
        )
    }
}


// MARK: - Logic
extension OnboardingRegisterScreen {
    var onConfirm: () -> Void {
        return {
            viewModel.isLoading = true
            if let auth = try? environment.getLomiApiAuth() {
                environment.lomiApi.register(
                    authToken: auth.authToken,
                    request: RegisterRequest(
                        lomiSerialNumber: viewModel.device.serialNumber.sanitized,
                        lomiName: viewModel.device.nickname.sanitized,
                        userId: auth.user.id
                    ),
                    onSuccess: {
                        (response: RegisterResponse?) -> Void in
                        if let response = response {
                            let serialPrefix = response.registration.lomiSerialNumber.prefix(6)
                            AnalyticsLogger.singleton.logEvent(
                                .registrationAdd,
                                parameters: [
                                    .itemVariant: String(serialPrefix.prefix(2)), // L# - Lomi version
                                    .itemCategory: String(serialPrefix.suffix(2)), // YY - year
                                    .source: "onboarding"
                                ]
                            )
                            viewModel.isLoading = false
                            viewModel.showingSuccess = true

                        } else {
                            viewModel.isLoading = false
                            environment.handleError(error: "ApiError.EmptyBody".localized())
                        }
                    },
                    onError:{
                        (apiError: LomiApiErrorResponse) -> Void in
                        viewModel.isLoading = false
                        environment.handleApiErrorResponse(apiError: apiError)
                    }
                )
            } else {
                viewModel.isLoading = false
                environment.handleError(error: "AuthError.NoAuth".localized())
            }
        }
    }
}

struct OnboardingRegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRegisterScreen(viewModel: AddDeviceViewController(device: Device()), onNext: {})
            .environmentObject(PreviewAppEnvironmentBuilder().build())
        
        // This is for checking indicator's position
        NavigationView {
            NavigationLink("Register Screen", isActive: Binding.constant(true)) {
                OnboardingRegisterScreen(viewModel: AddDeviceViewController(device: Device()), onNext: {})
                    .environmentObject(PreviewAppEnvironmentBuilder().build())
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .previewDevice("iPhone SE (1st generation)")
    }
}
