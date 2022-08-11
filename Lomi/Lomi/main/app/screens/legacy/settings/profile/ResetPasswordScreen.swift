//
//  ForgotPasswordView.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-18.
//

import SwiftUI

// A screen that allows the user to request a reset password email.
struct ResetPasswordScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingSuccess: Bool = false
    @State private var isLoading: Bool = false
    var onComplete: (()->Void)? = nil

    @State private var email = ""
    
    // FIXME: duplicated from SignUpViewModel, unify in the core user model
    private var emailPrompt: String {
        if (!RegexHelper.isValidEmail(text: email)) {
            return "Please enter a valid email address"
        }
        return ""
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 24) {
                Text("Forgot password?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 32)
                
                Text("Don't worry, it happens to the best of us. Enter your email below and we'll send you instructions to reset your password.")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 16)
                
                InputTextField(
                    field: $email,
                    inputType: .email,
                    prompt: emailPrompt
                )
                
                ButtonConfirm(
                    text: "Send",
                    disabled: !emailPrompt.isEmpty,
                    action: {
                        isLoading = true
                        environment.lomiApi.sendPasswordResetEmail(
                            email: email.sanitized,
                            onSuccess: {
                                (response: EmptyApiResponse?) -> Void in
                                isLoading = false
                                showingSuccess = true
                                AnalyticsLogger.singleton.logEvent(
                                    .userUpdate,
                                    parameters: [.method: "password"]
                                )
                            },
                            onError:{
                                (apiError: LomiApiErrorResponse) -> Void in
                                isLoading = false
                                showingSuccess = false
                                environment.handleApiErrorResponse(apiError: apiError)
                            }
                        )
                    }
                ).disabled(isLoading)
                
                Text("Check for an email to reset your password.")
                    .font(.caption)
                
                ButtonLink(
                    text: "Cancel",
                    action: onComplete ?? { presentationMode.wrappedValue.dismiss() }
                )
                .disabled(isLoading)
                
                Spacer()
                
            }
            .padding(.top)
            .padding(.horizontal)

            ProgressModal(showing: isLoading)
        }
        .onAppear(perform: {
            if let user = environment.currentUser {
                email = user.email
            }
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.userResetPassword]
            )
        })
        .alert(isPresented: $showingSuccess, content: {
            Alert(
                title: Text("Success"),
                message: Text("You will receive a password reset email in the next few minutes. Check for an email to reset your password!"),
                dismissButton: Alert.Button.default(Text("Ok"), action: onComplete ?? {presentationMode.wrappedValue.dismiss()})
            )
        })
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordScreen(onComplete: {}).environmentObject(PreviewAppEnvironmentBuilder().build())
    }
}
