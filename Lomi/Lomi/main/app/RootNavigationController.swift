//
//  RootNavigationController.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-06-29.
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
    
    init(appEnv: AppEnvironment) {
        super.init(nibName: nil, bundle: nil)
        self.tabBar.isHidden = true
        
        // FIXME: Set Main or Entry tabBarController instead of rootView
        let rootView = RootView()
            .environmentObject(appEnv)
            .onAppear {
                UIApplication.shared.addTapGestureRecognizer()
            }
        childViewController = UIHostingController(rootView: rootView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// TODO: Implement concrete functions
extension RootNavigationController {
    func goTo(route: [String], viewConfig: ((UIViewController) -> Void)) {
        
    }
    
    func replace(route: [String], viewConfig: ((UIViewController) -> Void)) {
        
    }
}

