//
//  EditUserLastNameScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-08.
//

import SwiftUI

// A screen that allows the user to edit their first (aka family) name.
struct EditUserLastNameScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @Environment(\.presentationMode) var presentationMode
    
    @State var showProgress: Bool = false
    @State private var newLastName = ""
    private var newLastNamePrompt: String {
        let count = newLastName.sanitized.count
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
                request: UpdateUserRequest(_id: auth.user.id, lastName: newLastName.sanitized),
                onSuccess: {
                    (response: UpdateUserResponse?) -> Void in
                    if let response = response {
                        do {
                            try environment.setLomiApiAuth(auth: LomiApiAuth(user: response.user, authToken: authToken))
                            AnalyticsLogger.singleton.logEvent(
                                .userUpdate,
                                parameters: [.itemCategory: "lastName"]
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
                Text("Edit Last Name")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                InputTextField(
                    field: $newLastName,
                    inputType: .lastName,
                    prompt: newLastNamePrompt
                )
                
                ButtonConfirm(
                    text: "Save",
                    disabled: !newLastNamePrompt.isEmpty,
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
                newLastName = user.lastName
            }
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.userEditLastName]
            )
        })
    }
}

struct EditUserLastNameScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditUserLastNameScreen()
            .environmentObject(
                PreviewAppEnvironmentBuilder()
                    .withLomiApiAuthRepository(authRepository: PreviewLomiApiAuthRepository.mockAuthRepository)
                    .build())
        
        EditUserLastNameScreen()
            .environmentObject(
                PreviewAppEnvironmentBuilder()
                    .build())
    }
}
