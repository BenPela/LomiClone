//
//  EditDeviceNameViewController.swift
//  Lomi
//
//  Created by Peter Harding on 2022-06-02.
//

import Foundation

final class EditDeviceNameViewController {
    let viewModel: EditDeviceNameViewModel
    let registerLomiService: RegisterLomiService

    init(viewModel: EditDeviceNameViewModel, registerLomiService: RegisterLomiService) {
        self.viewModel = viewModel
        self.registerLomiService = registerLomiService
    }

    func updateLomiName(
        registration: Registration,
        onSuccess: @escaping (_: Registration) -> Void,
        onFailure: @escaping () -> Void
    ) {
        viewModel.isLoading = true
        let newModel = Registration(
            id: registration.id,
            lomiSerialNumber: registration.lomiSerialNumber,
            lomiName: viewModel.device.nickname.sanitized,
            userId: registration.userId,
            createdAt: registration.createdAt
        )
        Task {
            let registration = await registerLomiService.updateRegistration(registration: newModel)
            if let updated = registration {
                // UI operations must be called from main thread
                // presentationMode.wrappedValue.dismiss() EditDeviceNameSreen:43
                await MainActor.run {
                    onSuccess(updated)
                }
                AnalyticsLogger.singleton.logEvent(
                    .registrationUpdate,
                    parameters: [
                        .itemCategory: "name"
                    ]
                )
            } else {
                onFailure()
            }
            await MainActor.run {
                viewModel.isLoading = false
            }
        }
    }

}
