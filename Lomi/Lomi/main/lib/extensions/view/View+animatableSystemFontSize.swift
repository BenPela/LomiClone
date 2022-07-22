//
//  View+animatableSystemFontSize.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-03-29.
//

import Foundation
import SwiftUI

/// A modifier that animates a system font through various sizes.
/// Specifying font-weight or custom font didn't work smooth and nicely so I limited only on system-font-size.
struct AnimatableSystemFontSizeModifier: AnimatableModifier {
    var size: CGFloat

    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
    }
}

extension View {
    /// Set an animation for system-font-size changes.
    ///
    /// The current SwiftUI(2.0) doesn't support animation for font size changes if you simply specify like
    /// ```
    /// // This doesn't reflect animation
    /// Text("text")
    ///     .font(.system(size: animationFlag ? 12 : 24))
    /// ```
    /// Instead, this function supports animation for only system-font-size changes by using custom modifier.
    /// ```
    /// // Usage example
    /// Text("text")
    ///     .animatableSystemFontSize(animationFlag ? 12 : 24)
    /// ```
    /// - Parameter size: Size of system font based on the current state. Here you can set font sizes using a ternary operator.
    func animatableSystemFontSize(_ size: CGFloat) -> some View {
        self.modifier(AnimatableSystemFontSizeModifier(size: size))
    }
}
