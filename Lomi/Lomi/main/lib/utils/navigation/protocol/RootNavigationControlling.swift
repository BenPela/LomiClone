//
//  RootNavigationControlling.swift
//  UIKitNavigationLab
//
//  Created by Takayuki Yamaguchi on 2022-06-24.
//

import SwiftUI

/// Main root class which is responsible for path based navigation
protocol RootNavigationControlling {
    /// A generic type which represents a `Path`
    associatedtype P
    /// A generic type which represents a viewConfig for the destination view. This will mostly be a closure.
    associatedtype C
    
    /// Navigate to the specific view of the graph based on the route.
    /// - We will keep **any existing children or leaf** related to the path.
    /// - The data or config will be **applied to the root view of the navigation**.
    /// - Parameters:
    ///   - route: A type which represents a `Path`. This will decide the destination
    ///   - viewConfig:  A viewConfig for the root view of the navigation hierarchy. This will mostly be a closure.
    func goTo(route: P, viewConfig: C)
    
    /// Navigate to the specific view of the graph based on the route.
    /// - **All existing children or leaf** related to the path will be deallocated.
    /// - The view specified by the path will be re-constructed.
    /// - The data or config will be **applied to the root view of the navigation**.
    /// - Parameters:
    ///   - route: A type which represents a `Path`. This will decide the destination
    ///   - viewConfig:  A viewConfig for the root view of the navigation hierarchy. This will mostly be a closure.
    func replace(route: P, viewConfig: C)
}


extension RootNavigationControlling {
    
    /// Return the most bottom root view controller of the window
    static func getWindowRootViewController() -> UIViewController?  {
        return keyWindow?.rootViewController
    }
    
    /// Get current top navigation controller. If there is any presented view, it will try to return a nav vc in the topmost preseted vc.
    static func getTopNavigationController(
        _ topViewController: UIViewController? = getWindowRootViewController(),
        asSwiftUINavigationController: Bool = true
    ) -> (some UINavigationController)? {
        return getTopViewController(topViewController)?.navigationController
    }

    /// Get current top view controller. If there is any presented view, it will try to return a vc in the topmost preseted vc.
    static func getTopViewController(
        _ topViewController: UIViewController? = getWindowRootViewController()
    ) -> UIViewController? {
        /*
         As long as the tabbar vc exist, `keyWindow` always returns the bottom tabbar vc even there are multiple presented view.
         Thus, if we check the presented vc first,
         and then, check the selected vc in the tab.
         
         T - N - T - N ...
         */
        if let presentedVc = topViewController?.presentedViewController {
            return getTopViewController(presentedVc)
        }
        
        if let navVc = topViewController as? UINavigationController {
            return getTopViewController(navVc.viewControllers.last)
        }
        
        if let tabBarVc = topViewController as? UITabBarController {
            return getTopViewController(tabBarVc.selectedViewController)
        }

        return topViewController
    }
    
    
    /// Dismiss all the presented viewControllers
    /// - Parameters:
    ///   - animated: Pass true to animate the transition.
    ///   - completion: The block to execute after the view controller is dismissed. This block has no return value and takes no parameters. You may specify nil for this parameter.
    static func dismissAll(animated: Bool = true, completion: (() -> Void)? = nil) {
        getWindowRootViewController()?.dismiss(animated: animated, completion: completion)
    }
    
    /// Get key window
    /// https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0/58031897#58031897
    private static var keyWindow: UIWindow? {
        
        if #available(iOS 15, *) {
            return  UIApplication
                .shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
}
