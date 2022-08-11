//
//  SignupNavigationController.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-07-25.
//

import Foundation

final class SignupNavigationController: SwiftUINavigationController {
    // These navigation functions will passed by EntryTabBarController
    // var goToHome: () -> Void
    
    override init() {
        super.init()
//        self.goToHome = goToHome
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: Navigations related to this NavControllers
extension SignupNavigationController {
//    func goToEmailConfirmation() {
//        push(viewType: EmailConfirmationScreen.self, view: EmailConfirmationScreen())
//    }
}
