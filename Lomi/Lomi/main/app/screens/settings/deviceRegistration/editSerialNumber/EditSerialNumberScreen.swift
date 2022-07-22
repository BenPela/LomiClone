//
//  EditSerialNumberScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-24.
//

import SwiftUI

// A screen that allows the user to edit the serial number of a Lomi registration.
struct EditSerialNumberScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: EditSerialNumberViewModel
    
    var body: some View {
        let viewController = EditSerialNumberViewController(viewModel: viewModel, registerLomiService: environment.serviceLocator.resolveService(RegisterLomiService.self)!)
        ZStack {
            VStack(alignment: .center, spacing: 24) {
                HStack {
                    Text("Edit Device Serial Number")
                        .fontWeight(.bold)
                    Spacer()
                }
                
                InputTextField(
                    field: $viewModel.device.serialNumber,
                    inputType: .deviceSerialNumber,
                    prompt: viewModel.serialNumberPrompt
                )
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.device.serialNumber) { [oldSerialNum = viewModel.device.serialNumber] newSerialNum in
                        viewModel.device.serialNumber = viewModel.isValidSerialNumInput(newSerialNum) ? newSerialNum : oldSerialNum
                    }
                
                ButtonConfirm(text: "Save", disabled: !viewModel.isAllValid() || viewModel.isLoading, action: {
                    guard let gRegistration = viewModel.device.registration else {
                        environment.handleError(error: "EditSerialNumberScreen registration not found on viewModel")
                        return
                    }
                    viewController.updateSerialNumber(registration: gRegistration, onSuccess: { updated in
                        let editIndex = environment.registrations.firstIndex(where: {$0.id == updated.id})
                        environment.registrations[editIndex.unsafelyUnwrapped] = updated
                        presentationMode.wrappedValue.dismiss()
                    }, onFailure: {
                        environment.handleError(error: "ApiError.EmptyBody".localized())
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
                        .screenName: AnalyticsScreenName.registrationEditSerialNumber,
                        .itemID: viewModel.device.registration?.id ?? "no_regisration_found",
                    ]
                )
            })
            
            ProgressModal(showing: viewModel.isLoading)
        }
    }
}

struct EditRegistrationSerialNumberView_Previews: PreviewProvider {
    static var previews: some View {
        let environment = PreviewAppEnvironmentBuilder().build()
        EditSerialNumberScreen(viewModel: EditSerialNumberViewModel(device: Device(registration: environment.registrations[0])))
            .environmentObject(environment)
    }
}
