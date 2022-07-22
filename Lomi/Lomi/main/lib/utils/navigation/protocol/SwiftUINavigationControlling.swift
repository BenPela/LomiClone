//
//  CustomNavigationController.swift
//  UIKitNavigationLab
//
//  Created by Takayuki Yamaguchi on 2022-06-17.
//

import SwiftUI
import UIKit

/// UINavigationController which manages **SwiftUI Views** as children UIViewControllers.
protocol SwiftUINavigationControlling: UINavigationController {
    /// This function is to setup RootView
    /// **This must be called during or right after the initialization**
    ///
    /// The `viewType` is to force passing a view without any view modifiers. When we use a view modifier, the result viewType will be changed too. This means we lose the ability to specify a view from the view controller. So later, we can not find tbe viewController which embraces `HomeView`
    /// ```swift
    ///     // This view type is not "UIHostingController<HomeView>"
    ///     // but UIHostingController<HomeViewWithSomeViewModifier>
    ///     UIHostingController(rootView: HomeView().ignoreSafeArea())
    /// ```
    ///
    /// - Parameters:
    ///   - viewType: ViewType of the Screen. This is for force passing a view without any modifier.
    ///   - view: The actual view instance. The return type must much to the `viewType`
    ///   - viewConfig: We can set up the wrapper viewController here. We can set a navigation config which we want to apply only to this viewController, such as title and back button UI.
    ///
    /// Example usage.
    ///  ```swift
    ///     nav.setupRootViewController(viewType: HomeScreen.self) {
    ///         HomeScreen()
    ///     } viewConfig: { homeVC in
    ///         homeVC.navigationItem.title = "Home Screen title"
    ///         homeVC.navigationItem.hidesBackButton = true
    ///     }
    ///
    ///  ```
    func setupRootViewController<V: View>(viewType: V.Type, view: V, viewConfig: ((UIViewController) -> Void)?)
    
    /// Push SwiftUI View as a UIViewController to the navigation controller
    /// When you push a view, it will automatically navigate to the next view which was added.
    ///
    /// The `viewType` is to force passing a view without any view modifiers. When we use a view modifier, the result viewType will be changed too. This means we lose the ability to specify a view from the view controller. So later, we can not find tbe viewController which embraces `HomeView`
    /// ```swift
    ///     // This view type is not "UIHostingController<HomeView>"
    ///     // but UIHostingController<HomeViewWithSomeViewModifier>
    ///     UIHostingController(rootView: HomeView().ignoreSafeArea())
    /// ```
    ///
    /// - Parameters:
    ///   - viewType: ViewType of the Screen. This is for force passing a view without any modifier.
    ///   - view: The actual view instance. The return type must much to the `viewType`
    ///   - viewConfig: We can set up the wrapper viewController here before its pushed to the navigation stack. Here, we can set a navigation config which we want to apply only to this viewController, such as title and back button UI.
    ///
    /// Example usage.
    ///  ```swift
    ///     nav.setupRootViewController(viewType: HomeScreen.self, view: HomeScreen()) { homeVC in
    ///         homeVC.navigationItem.title = "Home Screen title"
    ///         homeVC.navigationItem.hidesBackButton = true
    ///     }
    ///
    ///  ```
    func push<V: View>(viewType: V.Type, animated: Bool, view: V, viewConfig: ((UIViewController) -> Void)?)
    
    /// Pop all viewControllers(SwiftUI Views) until we find the target view. In other word, go back to the target view.
    /// All viewControllers popped will be deallocated.
    /// - Parameters:
    ///   - typeOfView: A target SwiftUI View that you want to go back
    ///   - animated: A right to lift transition animation if needed
    ///   - position: .firstFound will stop popping if you find the target view at the first time. See more description in the `PopPosition` type.
    /// - Returns: An array containing the view controllers that were popped from the stack.
    func popTo<T: View>(_ typeOfView: T.Type, animated: Bool, position: PopPosition) -> [UIViewController]?
}


/// This is for specifying which view to pop if there is duplication at a navigation controller
public enum PopPosition {
    /// This will pop views until we first found our desired view.
    /// E.g, [Root , A, B, A, C, A ,D] ->   pop to A first-found will be[Root , A, B, A, C, A]
    case firstFound
    /// This will pop views until we first found our desired view.
    /// E.g, [Root , A, B, A, C, A ,D] ->   pop to A last-found will be [Root , A]
    case lastFound
}

open class SwiftUINavigationController: UINavigationController, SwiftUINavigationControlling {
    
    /// When you call this, you must also **set up the rootView**
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init<V: View>(viewType: V.Type, view: V, viewConfig: ((UIViewController) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        setupRootViewController(viewType: viewType, view: view, viewConfig: viewConfig)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwiftUINavigationController {

    open func setupRootViewController<V: View>(viewType: V.Type, view: V, viewConfig: ((UIViewController) -> Void)?) {
        let rootViewController = UIHostingController(rootView: view)
        setViewControllers([rootViewController], animated: false)
        viewConfig?(rootViewController)
    }
    
    open func push<V: View>(viewType: V.Type, animated: Bool = true, view: V, viewConfig: ((UIViewController) -> Void)? = nil) {
        let vc = UIHostingController(rootView: view)
        viewConfig?(vc)
        self.pushViewController(vc, animated: animated)
    }
    
    @discardableResult 
    open func popTo<T: View>(_ typeOfView: T.Type, animated: Bool = true, position: PopPosition = .firstFound) -> [UIViewController]? {

        switch position {
        case .firstFound:
            if let vc = self.viewControllers.last(where: { $0 is UIHostingController<T> })  {
                return self.popToViewController(vc, animated: animated)
            }
        case .lastFound:
            if let vc = self.viewControllers.first(where: { $0 is UIHostingController<T> })  {
                return self.popToViewController(vc, animated: animated)
            }
        }
        return nil
    }
}


