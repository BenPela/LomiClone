//
//  EntryTabBarController.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-07-20.
//

import UIKit

final class EntryTabBarController: UITabBarController, EnumTabBarControlling {
    enum Tab: Int {
        case welcome
        case signup
        case login
    }
    
    func makeTab(_ tab: Tab) -> UIViewController {
        // TODO: Change to each specific navigationController later.
        switch tab {
        case .welcome:
            return UINavigationController()
        case .signup:
            return SignupNavigationController()
        case .login:
            return UINavigationController()
        }
    }
}
