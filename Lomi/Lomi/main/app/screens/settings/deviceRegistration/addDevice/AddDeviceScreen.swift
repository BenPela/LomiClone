//
//  RegisterScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-20.
//

import SwiftUI

// A screen that allows the user to register a new Lomi appliance.
struct AddDeviceScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewController: AddDeviceViewController
    @Binding var selectedRegistrationId: String

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center, spacing: 32) {
                    LomiDeviceHeader()
                    LomiDeviceContent(viewModel: viewController)
                    ButtonConfirm(text: "Save", disabled: !viewController.isAllValid() || viewController.isLoading, action: onConfirm)
                }.padding()
            }
            ProgressModal(showing: viewController.isLoading)
        }
        .onAppear(perform: {
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.register]
            )
        })
        .alert(isPresented: $viewController.showingSuccess, content: {
            Alert(
                title: Text("Success"),
                message: Text("Your Lomi has been registered!"),
                dismissButton: Alert.Button.default(
                    Text("Ok"), action: { presentationMode.wrappedValue.dismiss() }
                )
            )
        })
    }
}


// MARK: - Logic
extension AddDeviceScreen {
    var onConfirm: () -> Void {
        return {
            viewController.isLoading = true
            if let auth = try? environment.getLomiApiAuth() {
                environment.lomiApi.register(
                    authToken: auth.authToken,
                    request: RegisterRequest(
                        lomiSerialNumber: viewController.device.serialNumber.sanitized,
                        lomiName: viewController.device.nickname.sanitized,
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
                                    .source: "main"
                                ])
                            
                            viewController.isLoading = false
                            viewController.showingSuccess = true
                            
                            environment.registrations.append(response.registration)
                            selectedRegistrationId = response.registration.id
                        } else {
                            viewController.isLoading = false
                            viewController.showingSuccess = false
                            environment.handleError(error: "ApiError.EmptyBody".localized())
                        }
                    },
                    onError:{
                        (apiError: LomiApiErrorResponse) -> Void in
                        viewController.isLoading = false
                        viewController.showingSuccess = false
                        environment.handleApiErrorResponse(apiError: apiError)
                    }
                )
            } else {
                viewController.isLoading = false
                viewController.showingSuccess = false
                environment.handleError(error: "AuthError.NoAuth".localized())
            }
        }
    }
}


// MARK: - Preview

struct AddDevice_Previews: PreviewProvider {
    static var previews: some View {
        AddDeviceScreen(
            viewController: AddDeviceViewController(device: Device()),
            selectedRegistrationId: Binding.constant("")
        )
            .environmentObject(PreviewAppEnvironmentBuilder().build())
        
        // This is for checking indicator's position
        NavigationView {
            NavigationLink("Register Screen", isActive: Binding.constant(true)) {
                AddDeviceScreen(
                    viewController: AddDeviceViewController(device: Device()),
                    selectedRegistrationId: Binding.constant("")
                )
                    .environmentObject(PreviewAppEnvironmentBuilder().build())
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .previewDevice("iPhone SE (1st generation)")
    }
}
