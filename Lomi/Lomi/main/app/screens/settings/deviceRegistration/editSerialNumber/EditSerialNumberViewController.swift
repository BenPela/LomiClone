//
//  EditSerialNumberViewController.swift
//  Lomi
//
//  Created by Peter Harding on 2022-06-02.
//

import Foundation

final class EditSerialNumberViewController {
    let viewModel: EditSerialNumberViewModel
    let registerLomiService: RegisterLomiService

    init(viewModel: EditSerialNumberViewModel, registerLomiService: RegisterLomiService) {
        self.viewModel = viewModel
        self.registerLomiService = registerLomiService
    }

    func updateSerialNumber(
        registration: Registration,
        onSuccess: @escaping (_: Registration) -> Void,
        onFailure: @escaping () -> Void
    ) {
        viewModel.isLoading = true

        let newModel = Registration(
            id: registration.id,
            lomiSerialNumber: viewModel.device.serialNumber.sanitized,
            lomiName: registration.lomiName,
            userId: registration.userId,
            createdAt: registration.createdAt
        )

        Task {
            let registration = await registerLomiService.updateRegistration(registration: newModel)
            if let updated = registration {
                // UI operations must be called from main thread
                await MainActor.run {
                    onSuccess(updated)
                }
                AnalyticsLogger.singleton.logEvent(
                    .registrationUpdate,
                    parameters: [.itemCategory: "serialNumber"]
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
