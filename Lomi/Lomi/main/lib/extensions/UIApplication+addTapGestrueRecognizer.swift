//
//  UIApplication+EndEditing.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-08.
//

import UIKit

extension UIApplication {
    // https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
    /// Add tap recognizer. This is for dismissing keyboard when you tap outside of it.
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}
