//
//  NavigationController.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-05-20.
//

import SwiftUI

/// This is one of the way to solve `popToRoot` with SwiftUI
/// https://www.cuvenx.com/post/swiftui-pop-to-root-view
final class NavigationController: ObservableObject {
    @Published var rootViewId = UUID()
    
    func popToRoot() {
        rootViewId = UUID()
    }
}
