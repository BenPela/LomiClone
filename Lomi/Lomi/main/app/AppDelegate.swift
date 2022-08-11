//
//  AppDelegate.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-06-29.
//
import UIKit
import SwiftUI
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // FirebaseApp.configure() should be called **only once before any Firebase setup**.
        FirebaseApp.configure()
        
        // This is example of how to detect "launched by push notification" + "get its details"
        // if let userInfo =  launchOptions?[.remoteNotification] as? [AnyHashable: Any] { print(userInfo) }
        setupPushNotification(application: application)
        
        let serviceLocator = ServiceLocator()

        // FIXME: refactor to separate "AppEnvironment" from "StateCore"
        let appEnv = AppEnvironment(
            lomiApi: HttpClientLomiApi(httpClient: URLSessionHttpClient(), baseUrl: AppConfig.domain),
            authRepository: KeyChainLomiAuthRepository(),
            serviceLocator: serviceLocator
        )

        let userContainer = CoreDataContainer(dataModel: "UserData")
        let userRepository = UserRepository(stateContainer: userContainer)
        let authProvider = CognitoAuthProvider()
        let networkService = NetworkService(appEnv: appEnv)
        let userService = UserService(networkService: networkService, userRepository: userRepository)
        let registerLomiService = RegisterLomiService(networkService: networkService)
        let tipsService = TipsService(networkService: networkService)

        // MARK: Service Locator registrations
        serviceLocator.registerService(userService)
        serviceLocator.registerService(registerLomiService)
        serviceLocator.registerService(tipsService)

        let rootViewController = RootNavigationController()

        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
