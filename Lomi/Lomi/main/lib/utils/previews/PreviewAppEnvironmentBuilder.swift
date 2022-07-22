//
//  PreviewAppEnvironment.swift
//  Lomi
//
//  Created by Chris Worman on 2021-10-12.
//

import Foundation

// A builder that builds an AppEnvironment object meant for a view preview
class PreviewAppEnvironmentBuilder {
    public static var defaultRegistrations: Array<Registration> = [
        Registration(
            id: "registration-1",
            lomiSerialNumber: "687DSF6DSF323209F",
            lomiName: "Home",
            userId: "user-1",
            createdAt: "2021-09-03T20:08:38.812Z"),
        Registration(
            id: "registration-2",
            lomiSerialNumber: "09NNKQREERV47VF4U",
            lomiName: "Pool House",
            userId: "user-1",
            createdAt: "2021-08-05T20:08:38.812Z"),
        Registration(
            id: "registration-3",
            lomiSerialNumber: "09NNKQREERV57VF4U",
            lomiName: "BigBoiName Big Ol Name!",
            userId: "user-1",
            createdAt: "2021-08-05T20:08:38.812Z")
    ]

    public static var defaultRecentTipSummaries:  Array<Tip> = [
        Tip(
            id: "tipSummary-1",
            createdAt: "2021-09-03T20:08:38.812Z",
            title: "You should try this tip",
            image: ApiImage(url: "https://www.datocms-assets.com/48473/1628612317-tip-test-image-1.jpeg"),
            bookmarked: true),
        Tip(
            id: "tipSummary-2",
            createdAt: "2020-08-03T20:08:38.812Z",
            title: "Another tip with a longer title",
            image: ApiImage(url: "https://www.datocms-assets.com/48473/1628612349-tip-test-image-3.png"),
            bookmarked: false)]
    
    private var lomiApi: LomiApi? = nil
    private var authRepository: LomiApiAuthRepository? = nil
    private var registrations: Array<Registration>? = nil
    private var recentTipSummaries: Array<Tip>? = nil
    private var localStorage: AppLocalStorage = PreviewLocalStorage()

    func withLomiApi(lomiApi: LomiApi) -> PreviewAppEnvironmentBuilder {
        self.lomiApi = lomiApi
        return self
    }
    
    func withLomiApiAuthRepository(authRepository: LomiApiAuthRepository) -> PreviewAppEnvironmentBuilder {
        self.authRepository = authRepository
        return self
    }
    
    func withRegistrations(registrations: Array<Registration>) -> PreviewAppEnvironmentBuilder {
        self.registrations = registrations
        return self
    }
    
    func withRecentTipSummaries(recentTipSummaries: Array<Tip>) -> PreviewAppEnvironmentBuilder {
        self.recentTipSummaries = recentTipSummaries
        return self
    }
    
    func withTempUser(_ isTempUser: Bool) -> PreviewAppEnvironmentBuilder {
        self.localStorage.isTempUser = isTempUser
        return self
    }
    
    func build() -> AppEnvironment {
        let previewAppEnvironment = AppEnvironment(
            lomiApi: self.lomiApi ?? PreviewLomiApi(),
            authRepository: self.authRepository ?? PreviewLomiApiAuthRepository(),
            serviceLocator: ServiceLocator(),
            registrations: self.registrations ?? PreviewAppEnvironmentBuilder.defaultRegistrations,
            recentTipSummaries: self.recentTipSummaries ?? PreviewAppEnvironmentBuilder.defaultRecentTipSummaries
        )
        previewAppEnvironment.localStorage = self.localStorage
        
        previewAppEnvironment.showError = {
            (error: String) -> Void in
            SystemLogger.log.error(messages: "environment.showError \(error)")
        }
        
        previewAppEnvironment.handleUnauthorized = {
            SystemLogger.log.error(messages: "environment.handleUnauthorized")
        }
        
        previewAppEnvironment.handleLogout = { _ in
            try? self.authRepository?.clear()
            SystemLogger.log.error(messages: "environment.handleLogout")
        }
        
        return previewAppEnvironment
    }
}
