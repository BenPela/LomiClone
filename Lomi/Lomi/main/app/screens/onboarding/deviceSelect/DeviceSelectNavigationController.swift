//
//  DeviceSelectNavigationController.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-07-29.
//

import UIKit
import SwiftUI

final class DeviceSelectNavigationController: SwiftUINavigationController {
    // Navigation passed by higher level
    var goToHome: () -> Void
    
    init(goToHome: @escaping () -> Void) {
        self.goToHome = goToHome
        super.init()
        let rootView = DeviceSelectScreen(
            goToAddLomiV1: goToAddLomiV1,
            goToNameLomiV2: goToNameLomiV2,
            goToWebPela: goToWebPela,
            goToHome: goToHome
        )
        setupRootViewController(viewType: DeviceSelectScreen.self, view: rootView) { vc in
            vc.title = DeviceSelectStrings.screenTitle
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Navigations related to this NavControllers
extension DeviceSelectNavigationController {
    
    func goToAddLomiV1() {
        push(viewType: Text.self, view: Text("AddLomiV1"))
    }
    
    func goToNameLomiV2() {
        let view = NameLomiV2Screen(
            goToConnectLomiScreen: goToConnectLomiScreen,
            viewController: NameLomiV2Controller()
        )
        push(viewType: NameLomiV2Screen.self, view: view) { vc in
            vc.title = NameLomiV2Strings.screenTitle
        }
    }
    
    func goToWebPela() {
        if let url = URL(string: LomiWebLink.support.rawValue) {
            UIApplication.shared.open(url)
        }
    }
    
    func goToConnectLomiScreen(lomiName: String) {
        push(viewType: Text.self, view: Text("Connect Lomi Screen + Your Lomi name is \(lomiName)"))
    }
}
