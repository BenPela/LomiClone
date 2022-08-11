//
//  EditUserFirstNameScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-08.
//

import SwiftUI

// A screen that allows the user to edit their first (aka given) name.
struct EditUserFirstNameScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @Environment(\.presentationMode) var presentationMode
    
    @State var showProgress: Bool = false
    @State private var newFirstName = ""
    private var newFirstNamePrompt: String {
        let count = newFirstName.sanitized.count
        if count == 0 {
            return "Please enter your first name"
        }
        if AppDefault.NAME_RANGE.lowerBound > count {
            return "FisrtName must be at least \(AppDefault.NAME_RANGE.lowerBound) characters"
        }
        if AppDefault.NAME_RANGE.upperBound < count {
            return "FirstName must be within \(AppDefault.NAME_RANGE.upperBound) characters"
        }
        return ""
    }

    func save() {
        if let auth = try? environment.getLomiApiAuth() {
            showProgress = true
            let authToken = auth.authToken
            environment.lomiApi.updateUser(
                authToken: authToken,
                request: UpdateUserRequest(_id: auth.user.id, firstName: newFirstName.sanitized),
                onSuccess: {
                    (response: UpdateUserResponse?) -> Void in
                    if let response = response {
                        do {
                            try environment.setLomiApiAuth(auth: LomiApiAuth(user: response.user, authToken: authToken))
                            AnalyticsLogger.singleton.logEvent(
                                .userUpdate,
                                parameters: [
                                    .itemCategory: "firstName",
                                ]
                            )
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            environment.handleError(error: "AuthError.Persist".localized())
                        }
                    } else {
                        showProgress = false
                        environment.handleError(error: "ApiError.EmptyBody".localized())
                    }
                },
                onError: {
                    (apiError: LomiApiErrorResponse) -> Void in
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
                Text("Edit First Name")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                InputTextField(
                    field: $newFirstName,
                    inputType: .firstName,
                    prompt: newFirstNamePrompt
                )
                
                ButtonConfirm(
                    text: "Save",
                    disabled: !newFirstNamePrompt.isEmpty,
                    action: {
                        save()
                    }
                )
                    .disabled(showProgress)
                
                ButtonLink(
                    text: "Cancel",
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
                    .disabled(showProgress)
                
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
            
            
            ProgressModal(showing: showProgress)
        }
        .onAppear(perform: {
            if let user = environment.currentUser {
                newFirstName = user.firstName
            }
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.userEditFirstName]
            )
        })

    }
}

struct EditUserFirstNameScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditUserFirstNameScreen()
            .environmentObject(
                PreviewAppEnvironmentBuilder()
                    .withLomiApiAuthRepository(authRepository: PreviewLomiApiAuthRepository.mockAuthRepository)
                    .build())
        
        EditUserFirstNameScreen()
            .environmentObject(
                PreviewAppEnvironmentBuilder()
                    .build())
    }
}
