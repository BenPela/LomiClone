//
//  onboardingTabBarController.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-07-29.
//

import UIKit

final class OnboardingTabBarController: UITabBarController, EnumTabBarControlling {
    enum Tab: Int {
        case deviceSelect
    }
    
    var goToHome: () -> Void
    
    init(goToHome: @escaping () -> Void) {
        self.goToHome = goToHome
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [makeTab(.deviceSelect)]
        self.tabBar.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension OnboardingTabBarController {
    func makeTab(_ tab: Tab) -> UIViewController {
        switch tab {
        case .deviceSelect:
            return DeviceSelectNavigationController(goToHome: goToHome)
        }
    }
}
