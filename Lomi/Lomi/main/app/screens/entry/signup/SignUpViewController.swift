//
//  SignUpViewController.swift
//  Lomi
//
//  Created by Peter Harding on 2022-06-02.
//

import Foundation

final class SignUpViewController {
    private let viewModel: SignUpViewModel
    private let userService: UserService

    init(viewModel: SignUpViewModel, userService: UserService) {
        self.viewModel = viewModel
        self.userService = userService
    }

    func createUser(
        onSuccess: @escaping () -> Void,
        onFailure: @escaping () -> Void
    ) {
        viewModel.isLoading = true
        Task {
            let request = CreateUserRequest(
                firstName: viewModel.firstName,
                lastName: viewModel.lastName,
                email: viewModel.email,
                password: viewModel.password
            )
            let response = await userService.createUser(request)
            if (response != nil) {
                viewModel.isLoading = false
                AnalyticsLogger.singleton.logEvent(
                    .signUp,
                    parameters: [.method: "email"]
                )
                onSuccess()
            } else {
                onFailure()
                viewModel.isLoading = false
            }
        }
    }

}
