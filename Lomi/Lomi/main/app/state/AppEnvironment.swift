//
//  GlobalState.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-03.
//

import Foundation

// A container for common app dependencies, such as a Lomi API client and a authorization repository.
class AppEnvironment: ObservableObject {
    @Published var registrations: Array<Registration> = []
    @Published var recentTipSummaries: Array<Tip> = []
    @Published var currentUser: User? = nil
    var handleUnauthorized: (() -> Void)? = nil
    var handleLogout: ((_ : EntryScreen.CurrentScreen?) -> Void)? = nil
    var showError: ((_: String) -> Void)? = nil
    var lomiApi: LomiApi
    private var authRepository: LomiApiAuthRepository
    var serviceLocator: ServiceLocating
    var localStorage: AppLocalStorage = LocalStorage()
    
    init(
        lomiApi: LomiApi,
        authRepository: LomiApiAuthRepository,
        serviceLocator: ServiceLocating,
        registrations: Array<Registration> = [],
        recentTipSummaries: Array<Tip> = []
    ) {
        self.lomiApi = lomiApi
        self.authRepository = authRepository
        self.serviceLocator = serviceLocator
        self.registrations = registrations
        self.recentTipSummaries = recentTipSummaries
        if let auth = try? self.authRepository.get() {
            currentUser = auth.user
        }
    }
    
    init(lomiApi: LomiApi, authRepository: LomiApiAuthRepository, serviceLocator: ServiceLocating) {
        self.lomiApi = lomiApi
        self.authRepository = authRepository
        self.serviceLocator = serviceLocator
        if let auth = try? self.authRepository.get() {
            currentUser = auth.user
        }
    }

    // FIXME: should capture error, or just be removed after refactor
    func getLomiApiAuth() throws -> LomiApiAuth? {
        return try authRepository.get()
    }
    
    func setLomiApiAuth(auth: LomiApiAuth) throws -> Void {
        try authRepository.set(auth: auth)
        currentUser = auth.user
    }
    
    func handleApiErrorResponse(apiError: LomiApiErrorResponse, isAuthAttempt: Bool = false) {
        SystemLogger.log.error(messages: apiError.userErrorMessage)
        if apiError.isUnauthorized() && !isAuthAttempt {
            self.registrations = []
            self.recentTipSummaries = []
            self.currentUser = nil
            do {
                try self.authRepository.clear()
            } catch {
                SystemLogger.log.error(messages:"AppEnvironment.handleApiErrorResponse: \(apiError.userErrorMessage)")
            }
            if let handleUnauthorized = self.handleUnauthorized {
                handleUnauthorized()
            }
        // Note: We are going to handle `unverified` independently only at the login screen. This is because there are no other places that API returns `unverified`. However, if users change their email and if we don't let them log out, their status will be `unverified`. This won't happen because we always force logout after users update the email, but leaving this just in case.
        } else if apiError.isUnverified() {
            handleError(error: "ApiError.Unverified".localized())
        } else {
            handleError(error: apiError.userErrorMessage)
        }
    }
    
    func handleError(error: String) {
        SystemLogger.log.error(messages: "GlobalState.handleError \(error)")
        if let showError = showError {
            showError(error)
        }
    }
    
    func showUnauthorizedLoginScreen() {
        if let handleUnauthorized = self.handleUnauthorized {
            handleUnauthorized()
        }
    }

    func logout(to screen: EntryScreen.CurrentScreen? = .login) throws {
        try authRepository.clear()
        self.currentUser = nil
        localStorage.isTempUser = false
        if let handleLogout = self.handleLogout {
            handleLogout(screen)
        }
    }
}
