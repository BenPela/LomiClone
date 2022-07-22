//
//  SwiftUINavigationControllerTest.swift
//  LomiTests
//
//  Created by Takayuki Yamaguchi on 2022-07-05.
//

import XCTest
import SwiftUI
import UIKit
@testable import Lomi

class SwiftUINavigationControllerTest: XCTestCase {
    
    private var navController: SwiftUINavigationController!

    override func setUp() {
        super.setUp()
        navController = SwiftUINavigationController()
        navController.popTo(MockSwiftUIViewA.self)
    }
    override func tearDown() {
        navController = nil
        super.tearDown()
    }
    
    // MARK: - Root view
    func testInitializerWithRootView() {
        let nav = SwiftUINavigationController(viewType: MockSwiftUIViewA.self, view: MockSwiftUIViewA())
        XCTAssertEqual(nav.viewControllers.count, 1)
        XCTAssert(nav.children.last is UIHostingController<MockSwiftUIViewA>)
    }

    func testSetupRootViewController () {
        navController.setupRootViewController(viewType: MockSwiftUIViewA.self, view: MockSwiftUIViewA(), viewConfig: nil)
        XCTAssertEqual(navController.viewControllers.count, 1)
        XCTAssert(navController.children.last is UIHostingController<MockSwiftUIViewA>)
    }
    
    func testSetupRootViewControllerViewConfig () {
        let title = "Mock A"
        navController.setupRootViewController(viewType: MockSwiftUIViewA.self, view: MockSwiftUIViewA())  { vc in
            vc.title = title
        }
        XCTAssertEqual(navController.children.first?.title, title)
    }
    
    func testSetupRootViewControllerReplace () {
        navController.setupRootViewController(viewType: MockSwiftUIViewA.self, view: MockSwiftUIViewA(), viewConfig: nil)
        navController.setupRootViewController(viewType: MockSwiftUIViewB.self, view: MockSwiftUIViewB(), viewConfig: nil)
        XCTAssertEqual(navController.viewControllers.count, 1)
        XCTAssert(navController.children.last is UIHostingController<MockSwiftUIViewB>)
    }
    
    
    // MARK: - Push
    func testPushView() {
        navController.viewControllers = [
            MockUIKitVcA(),
            MockUIKitVcB()
        ]
        navController.push(viewType: MockSwiftUIViewA.self, animated: false, view: MockSwiftUIViewA())
        XCTAssertEqual(navController.viewControllers.count, 3)
        XCTAssert(navController.children.last is UIHostingController<MockSwiftUIViewA>)
    }
    
    func testPushViewAndUIKitView() {
        navController.viewControllers = [
            MockUIKitVcB(),
            MockSwiftUIVcB()
        ]
        navController.push(viewType: MockSwiftUIViewA.self, animated: false, view: MockSwiftUIViewA())
        navController.pushViewController(MockUIKitVcA(), animated: false)
        XCTAssertEqual(navController.viewControllers.count, 4)
        XCTAssert(navController.children[3] is MockUIKitVcA)
        XCTAssert(navController.children[2] is UIHostingController<MockSwiftUIViewA>)
    }
    
    func testPushWithViewConfig () {
        navController.push(viewType: MockSwiftUIViewA.self, animated: false, view: MockSwiftUIViewA()) { vc in
            vc.navigationItem.hidesBackButton = false
        }
        XCTAssert(navController.children.last?.navigationItem.hidesBackButton == false)
    }
    
    
    // MARK: - Pop to
    func testPopToViewFirstFound() {
        let viewControllers = [
            MockSwiftUIVcB(), //
            MockSwiftUIVcA(),
            MockUIKitVcA(),
            MockSwiftUIVcA(), //
            MockSwiftUIVcB(),
            MockSwiftUIVcA(), // <- Target
            MockUIKitVcB()
        ]
        navController.viewControllers = viewControllers
        let popped = navController.popTo(MockSwiftUIViewA.self, animated: false, position: .firstFound)
        XCTAssertEqual(popped, [viewControllers[6]])
        XCTAssertEqual(navController.children, Array(viewControllers[0...5]))
    }
    
    func testPopToViewLastFound() {
        let viewControllers = [
            MockSwiftUIVcB(),
            MockSwiftUIVcA(), // <- Target
            MockUIKitVcA(),
            MockSwiftUIVcA(), //
            MockSwiftUIVcB(),
            MockSwiftUIVcA(), //
            MockUIKitVcB()
        ]
        navController.viewControllers = viewControllers
        let popped = navController.popTo(MockSwiftUIViewA.self, animated: false, position: .lastFound)
        XCTAssertEqual(popped, Array(viewControllers[2...6]))
        XCTAssertEqual(navController.children, Array(viewControllers[0...1]))
    }
    
    func testPopToViewNotFound() {
        // No target
        let viewControllers = [
            MockSwiftUIVcB(),
            MockUIKitVcA(),
            MockSwiftUIVcB(),
            MockUIKitVcB()
        ]
        navController.viewControllers = viewControllers
        let popped = navController.popTo(MockSwiftUIViewA.self, animated: false, position: .firstFound)
        XCTAssertNil(popped)
        XCTAssertEqual(navController.children, viewControllers)
    }

}


// MARK: - Mock
extension SwiftUINavigationControllerTest {
    // SwiftUI Views
    struct MockSwiftUIViewA: View {
        var body: some View {
            EmptyView()
        }
    }
    struct MockSwiftUIViewB: View {
        var body: some View {
            EmptyView()
        }
    }
    // ViewControllers
    class MockSwiftUIVcA: UIHostingController<MockSwiftUIViewA> {
        init() {
            super.init(rootView: MockSwiftUIViewA())
        }
        @MainActor required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class MockSwiftUIVcB: UIHostingController<MockSwiftUIViewB> {
        init() {
            super.init(rootView: MockSwiftUIViewB())
        }
        @MainActor required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    /// This is a pure UIViewController. This is to prove that we can mix using both SwiftUIViews and UIViewControllers
    class MockUIKitVcA: UIViewController {
        override func viewDidLoad() {
            self.view = UIView()
        }
    }
    class MockUIKitVcB: UIViewController {
        override func viewDidLoad() {
            self.view = UIView()
        }
    }
}
