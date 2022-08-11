//
//  RootNavigationController.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-07-19.
//

import UIKit
import SwiftUI

final class RootNavigationController: UITabBarController, RootNavigationControlling {
    /// This viewController will be the basic tabBarController for the app. For example "Main" or "Entry".
    ///
    /// **Concept**
    /// - We will **not** set a "Main" or "Entry" tabBar or any basic tabBar directly to the `window.rootViewController` and switch each other,
    /// - Instead, we will wrap it with a root TabBarController (which is a `RootNavigationController`)
    /// - This rootNavigationController will have a **single child(tab)**, not multiple tabs. And this will be a  "Main" or "Entry" tabBar
    ///```
    /// 🚫 window.rootViewController == Entry tabBarController or Main tabBarController
    /// 🚫 window.rootViewController == RootNavigationController(tabBarController)
    ///                                    |
    ///                              [Entry, Main, ...other basic tabBarController] as multiple children
    /// ✅ window.rootViewController == RootNavigationController(tabBarController)
    ///                                    |
    ///                              [A Single Child] == Entry, Main or other basic tabBarController
    ///```
    /// **Reasons**
    /// - Why wrapping by root tabBar?
    ///     1. It is natural to have a stable rootViewController (which won't deallocate) and switch internal sub-basic tabBars to each other.
    ///     2. We can present a viewController on this rootViewController. Since this rootViewController won't be deallocate, we can have a global modal view which won't be deallocated where ever we jump to a different view.
    /// - Why a single child?
    ///     1. This is for **not keeping other basic tabs**
    ///     2. Because this is a tabBarController. If we set like [Entry , Main] , and move from Entry to Main, the Entry tabbar will not be deallocated
    ///     3. This is good if we want to keep other tabBar, however, it will be bad for a memory perspective.
    private var childViewController: UIViewController? {
        get {
            self.viewControllers?.first
        }
        set {
            guard let vc = newValue else { return }
            self.viewControllers = nil
            self.viewControllers = [vc]
        }
    }
    
    var entryTabBarController: EntryTabBarController?
    var onboardingTabBarController: OnboardingTabBarController?
    var mainTabBarController: MainTabBarController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBar.isHidden = true

        switchToOnboarding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// TODO: Implement concrete functions
extension RootNavigationController {
    func goTo(route: NavPath, viewConfig: ((UIViewController?) -> Void)? = nil) {
        navigateTo(route, replace: false, viewConfig: viewConfig)
    }
    
    func replace(route: NavPath, viewConfig: ((UIViewController?) -> Void)? = nil) {
        navigateTo(route, replace: true, viewConfig: viewConfig)
    }
}


// MARK: - Helpers
private extension RootNavigationController {
    /// Navigation function which is responsible for **First level** of the path.
    ///
    ///  e.g.  If the path is ["Entry", "A"], it will evaluate first element "Entry", and pass the **trimmed path ["A"]** to next function.
    ///
    func navigateTo(_ route: NavPath, replace: Bool, viewConfig: ((UIViewController?) -> Void)?) {
        switch route.first {
        case .entry:
            switchToEntry()
            navigateToEntry(Array(route.dropFirst()), replace: replace, viewConfig: viewConfig)
        case .main:
            switchToMain()
            navigateToMain(Array(route.dropFirst()), replace: replace, viewConfig: viewConfig)
        default:
            break
        }
    }
    
    /// Navigation function which is responsible for **Second level** of the path,  under **Entry** section.
    ///
    ///  The path is already trimmed so you only have to evaluate the first element.
    ///
    func navigateToEntry(_ route: NavPath, replace: Bool, viewConfig: ((UIViewController?) -> Void)?) {
        switch route.first {
        case .welcome:
            entryTabBarController?.switchTabTo(.welcome, replace: replace, viewConfig: viewConfig)
        case .signup:
            entryTabBarController?.switchTabTo(.signup, replace: replace, viewConfig: viewConfig)
        case .login:
            entryTabBarController?.switchTabTo(.login, replace: replace, viewConfig: viewConfig)
        default:
            break
        }
    }
    
    /// Navigation function which is responsible for **Second level** of the path,  under **Onboarding** section.
    ///
    ///  The path is already trimmed so you only have to evaluate the first element.
    ///
    func navigateToOnboarding(_ route: NavPath, replace: Bool, viewConfig: ((UIViewController?) -> Void)?) {
        switch route.first {
        case .deviceSelect:
            onboardingTabBarController?.switchTabTo(.deviceSelect, replace: replace, viewConfig: viewConfig)
        default:
            break
        }
    }
    
    /// Navigation function which is responsible for **Second level** of the path, under **Main** section.
    ///
    ///  The path is already trimmed so you only have to evaluate the first element.
    ///
    func navigateToMain(_ route: NavPath, replace: Bool, viewConfig: ((UIViewController?) -> Void)?) {
        // TODO: Add Main screens
    }
    
    
    /// Switch to EntryTabBarController only if needed.
    /// (If it is already `Entry`, do nothing.)
    ///
    /// If it is `Main` or `Onboarding`, a new `Entry`tabBarController is created and others are deallocated.
    func switchToEntry() {
        if entryTabBarController == nil {
            mainTabBarController = nil
            onboardingTabBarController = nil
            entryTabBarController = EntryTabBarController()
            childViewController = entryTabBarController
        }
    }
    
    /// Switch to OnboardingTabBarController only if needed.
    /// (If it is already `Onboarding`, do nothing.)
    ///
    /// If it is `Main` or `Entry`, a new `Onboarding`tabBarController is created and others are deallocated.
    func switchToOnboarding() {
        if onboardingTabBarController == nil {
            entryTabBarController = nil
            mainTabBarController = nil
            onboardingTabBarController = OnboardingTabBarController(goToHome: goToHome)
            childViewController = onboardingTabBarController
        }
    }
    
    /// Switch to MainTabBarController only if needed.
    /// (If it is already `Main`, do nothing.)
    ///
    /// If it is `Entry` or `Onboarding`, a new `Main`tabBarController is created and others are deallocated.
    func switchToMain() {
        if mainTabBarController == nil {
            entryTabBarController = nil
            onboardingTabBarController = nil
            mainTabBarController = MainTabBarController()
            childViewController = mainTabBarController
        }
    }
}


// MARK: - Actual navigations
// These functions will be passed to each NavigationController
private extension RootNavigationController {
    func goToHome() {
        // TODO: Add navigation to home screen
        SystemLogger.log.debug(messages: "Go to Home Screen")
//        navigateTo(NavPath.Main.home, replace: true, viewConfig: nil)
    }
}
