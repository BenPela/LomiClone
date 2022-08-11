//
//  EditDeviceNameScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-24.
//

import SwiftUI

// A screen that allows the user to edit the name of a Lomi registration.
struct EditDeviceNameScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: EditDeviceNameViewModel
    
    var body: some View {
        let viewController = EditDeviceNameViewController(
            viewModel: viewModel,
            registerLomiService: environment.serviceLocator.resolveService(RegisterLomiService.self)!
        )
        ZStack {
            VStack(alignment: .center, spacing: 24) {
                HStack {
                    Text("Edit Device Nickname")
                        .fontWeight(.bold)
                    Spacer()
                }
                
                InputTextField(
                    field: $viewModel.device.nickname,
                    inputType: .deviceNickname,
                    prompt: viewModel.nicknamePrompt
                )
                
                ButtonConfirm(text: "Save", disabled: !viewModel.isAllValid() || viewModel.isLoading, action: {
                    guard let gRegistration = viewModel.device.registration else {
                        environment.handleError(error: "EditDeviceNameScreen registration not found on viewModel")
                        return
                    }
                    viewController.updateLomiName(registration: gRegistration, onSuccess: { updated in
                        let editIndex = environment.registrations.firstIndex(where: {$0.id == updated.id})
                        environment.registrations[editIndex.unsafelyUnwrapped] = updated
                        presentationMode.wrappedValue.dismiss()
                    }, onFailure: {
                        // TODO: new way of showing API error messages
                        environment.handleError(error: "Could not update Lomi registration")
                    })
                })
                
                ButtonLink(text: "Cancel", action: {
                    presentationMode.wrappedValue.dismiss()
                }).disabled(viewModel.isLoading)
                
                Spacer()
            }
            .padding(.top, 32)
            .padding(.horizontal)
            .onAppear(perform: {
                AnalyticsLogger.singleton.logEvent(
                    .screenView,
                    parameters: [
                        .screenName: AnalyticsScreenName.registrationEditName,
                        .itemID: viewModel.device.registration?.id ?? "no_registration_found",
                    ]
                )
            })
            
            ProgressModal(showing: viewModel.isLoading)
        }
    }
}

struct EditRegistrationNameView_Previews: PreviewProvider {
    static var previews: some View {
        let environment = PreviewAppEnvironmentBuilder().build()
        EditDeviceNameScreen(viewModel: EditDeviceNameViewModel(device: Device(registration: environment.registrations[0])))
            .environmentObject(environment)
    }
}
