//
//  View+display.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-12-15.
//

import SwiftUI

extension View {
    /// display view under given condition. False will return EmptyView which doesn't have space.
    @ViewBuilder func display(_ when: Bool) -> some View {
        switch when {
        case true: self
        case false: EmptyView()
        }
    }
}
