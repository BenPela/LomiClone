//
//  MainTabBarController.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-07-20.
//

import UIKit

/// This manages screens for `Main` section.
final class MainTabBarController: UITabBarController, EnumTabBarControlling {
    enum Tab: Int {
        case home
    }
    
    func makeTab(_ tab: Tab) -> UIViewController {
        // TODO: Change to each specific navigationController later.
        return UINavigationController()
    }
}
