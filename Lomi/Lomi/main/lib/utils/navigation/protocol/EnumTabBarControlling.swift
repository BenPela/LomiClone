//
//  SwiftUITabBarController.swift
//  UIKitNavigationLab
//
//  Created by Takayuki Yamaguchi on 2022-06-17.
//

import SwiftUI
import UIKit

/// UITabbarController which tab is managed by enum.
protocol EnumTabBarControlling: UITabBarController {
    /// Every class must have a enum which represents a tab of the tabBarController. e,g welcome, signup, login
    associatedtype T : RawRepresentable where Self.T.RawValue == Int
    
    /// Set tabs (children viewController) of the TabBarController. **This method must be called during or right after the initialization**.
    /// - Parameters:
    ///   - tabs: Array of navigationControllers that represent tabs of the TabBarController
    ///   - defaultTab: default tab you want to display
    func setupTabBarController(tabs: [UIViewController], defaultTab: T)
    
    /// Switch to the specified tab. When we switch, the other tabs are **not deallocated**.
    /// - Parameters:
    ///   - tab: a target tab you want to go
    ///   - replace: if this is true, we will reset the current tab, which means we will re-create a viewController or a navigationController in the target tab.
    ///   - viewConfig: A viewConfig which will be set to the **rootVC of the navigation stack**.
    func switchTabTo(_ tab: T, replace: Bool, viewConfig: ((UIViewController?) -> ())?)
    
    /// Create a child viewController (or a navigationController) based on the specified tab. This function associates the tab and its child view controller
    /// - Parameter tab: Target tab
    /// - Returns: When you select the target `tab`, this navigation controller will be displayed
    func makeTab(_ tab: T) -> UIViewController
}

extension EnumTabBarControlling {
    
    func setupTabBarController(tabs: [UIViewController], defaultTab: T) {
        self.viewControllers = tabs
    }
    
    func switchTabTo(_ tab: T, replace: Bool = false, viewConfig: ((UIViewController?) -> ())? = nil)  {
        // Guarantee that the destination tab exists.
        guard let count = self.viewControllers?.count, count > tab.rawValue else { return }
        
        if replace {
            // Re-create the specified navigation vc
            self.viewControllers?[tab.rawValue] = makeTab(tab)
        }
        
        // Set custom configuration to the very bottom (root) of the navigation stack before it is displayed.
        // We can pass data through this for example.
        if let nvc = self.viewControllers?[tab.rawValue] as? UINavigationController {
            viewConfig?(nvc.viewControllers.first)
        } else if let vc = self.viewControllers?[tab.rawValue] as? UIViewController {
            viewConfig?(vc)
        }
        
        // animation if needed
//        if let from = selectedViewController?.view, let to = viewControllers?[tab.rawValue].view, from != to {
//            UIView.transition(from: from, to: to, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
//        }
        
        self.selectedIndex = tab.rawValue
    }
    
}
