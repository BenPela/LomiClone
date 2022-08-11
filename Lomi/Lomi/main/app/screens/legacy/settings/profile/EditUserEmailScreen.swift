//
//  EditUserEmailScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-14.
//

import SwiftUI

// A screen that allows the user to edit their email address.
struct EditUserEmailScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @Environment(\.presentationMode) var presentationMode

    @State var showProgress: Bool = false
    @State var showingEmailVerificationAlert: Bool = false
    
    @State private var newEmail = ""
    
    // FIXME: duplicated from SignUpViewModel, unify in the core user model
    var newEmailPrompt: String {
        if (!RegexHelper.isValidEmail(text: newEmail)) {
            return "Please enter a valid email address"
        }
        return ""
    }
    
    func save() {
        if let auth = try? environment.getLomiApiAuth() {
            showProgress = true
            let authToken = auth.authToken
            environment.lomiApi.updateUserEmail(
                authToken: authToken,
                request: UpdateUserEmailRequest(_id: auth.user.id, email: newEmail.sanitized),
                onSuccess: {
                    (response: UpdateUserEmailResponse?) -> Void in
                    showProgress = false
                    if let response = response {
                        do {
                            try environment.setLomiApiAuth(auth: LomiApiAuth(user: response.user, authToken: authToken))
                            showingEmailVerificationAlert = true
                            AnalyticsLogger.singleton.logEvent(
                                .userUpdate,
                                parameters: [.itemCategory: "email"]
                            )
                        } catch {
                            environment.handleError(error: "AuthError.Persist".localized())
                        }
                    } else {
                        environment.handleError(error: "ApiError.EmptyBody".localized())
                    }
                },
                onError: {
                    (apiError: LomiApiErrorResponse) -> Void in
                    showProgress = false
                    environment.handleApiErrorResponse(apiError: apiError)
                })
        } else {
            showProgress = false
            environment.handleError(error: "AuthError.NoAuth".localized())
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 24) {
                Text("Change Email Address")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("UserEmailUpdate.Warning".localized())
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                InputTextField(
                    field: $newEmail,
                    inputType: .email,
                    prompt: newEmailPrompt
                )
                
                ButtonConfirm(
                    text: "Save",
                    disabled: !newEmailPrompt.isEmpty,
                    action: {
                        save()
                    }
                ).disabled(showProgress)
                
                ButtonLink(
                    text: "Cancel",
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    }
                ).disabled(showProgress)
                
                Spacer()

            }
            .padding(.top)
            .padding(.horizontal)
            
            ProgressModal(showing: showProgress)
        }
        .onAppear(perform: {
            if let user = environment.currentUser {
                newEmail = user.email
            }
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.userEditEmail]
            )
        })
        .alert(isPresented: $showingEmailVerificationAlert, content: {
            Alert(
                title: Text("UserEmailUpdate.AlertTitle".localized()),
                message: Text("UserEmailUpdate.AlertText".localized()),
                dismissButton: .default(Text("Ok"), action: {
                    presentationMode.wrappedValue.dismiss()
                    environment.showUnauthorizedLoginScreen()
                }))
        })
    }
}

struct EditUserEmailScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditUserEmailScreen()
            .environmentObject(
                PreviewAppEnvironmentBuilder()
                    .withLomiApiAuthRepository(authRepository: PreviewLomiApiAuthRepository.mockAuthRepository)
                    .build())
        
        EditUserEmailScreen()
            .environmentObject(
                PreviewAppEnvironmentBuilder()
                    .build())
    }
}
