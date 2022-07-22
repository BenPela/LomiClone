//
//  View+shadow.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-12-27.
//

import SwiftUI

extension View {
    func ctaButtonShadow(disable: Bool = false) -> some View {
        self.shadow(
                color: Color(.sRGB, red: 80/255, green: 80/255, blue: 80/255, opacity: disable ? 0 : 0.25),
                radius: 5,
                x: 0,
                y: 2
            )
    }
}
