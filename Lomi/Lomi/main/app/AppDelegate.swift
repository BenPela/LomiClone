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
        
        let serviceLocator = ServiceLocator()

        // FIXME: refactor to separate "AppEnvironment" from "StateCore"
        let appEnv = AppEnvironment(
            lomiApi: HttpClientLomiApi(httpClient: URLSessionHttpClient(), baseUrl: AppConfig.domain),
            authRepository: KeyChainLomiAuthRepository(),
            serviceLocator: serviceLocator
        )

        let authProvider = CognitoAuthProvider()
        let networkService = NetworkService(appEnv: appEnv)
        let userService = UserService(networkService: networkService)
        let registerLomiService = RegisterLomiService(networkService: networkService)
        let tipsService = TipsService(networkService: networkService)

        // MARK: Service Locator registrations
        serviceLocator.registerService(userService)
        serviceLocator.registerService(registerLomiService)
        serviceLocator.registerService(tipsService)
        
        let rootViewController = RootNavigationController(appEnv: appEnv)
        
        setUpNavigationBar()
        setUpTabBar()

        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}


extension AppDelegate {
    func setUpNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = UIColor(.inputFieldsOffWhite)
        /*
         This will hide the navigation bar title, but internally let it exist. This makes the back button label dynamically related to the current navigation title.
         The below solution doesn't work nicely because it will also make the back button label "".
         ```
         .navigationBarHidden(true)
         .navigationBarTitle("")
         ```
         */
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.clear, .font: UIFont.systemFont(ofSize: 0)]
        // This will customize all back button style in navigation bar. This has no effect on BackIndicatorImage "<"
        navBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(.primarySoftBlack), .font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        // This will change tintColor of all navigation bar's "title", "back bottom", and "BackIndicatorImage". However, `UINavigationBarAppearance()` config has high priority.
        UINavigationBar.appearance().tintColor = UIColor(.primarySoftBlack)
        
        // Applying appearance to all navigation status.
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    func setUpTabBar() {
        // Set up tab bar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(.primaryWhite)
        tabBarAppearance.stackedItemPositioning = .centered
        UITabBar.appearance().standardAppearance = tabBarAppearance
        // This is to always show same tab appearance (eg, border)
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        } else {
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().isTranslucent = true
            UITabBar.appearance().backgroundColor =  .white
        }
    }

}
