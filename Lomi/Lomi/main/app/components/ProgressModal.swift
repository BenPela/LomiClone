//
//  ProgressModal.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-18.
//

import SwiftUI

// A view showing a progress indicator modally
struct ProgressModal: View {
    var showing: Bool
    
    var body: some View {
        if showing {
            VStack {
                ZStack {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .background(Color.white)
                        .opacity(0.2)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 100, height: 100)
                        .shadow(radius: 5)
                        .foregroundColor(.white)
                        .opacity(1)
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.1)))
            .allowsHitTesting(true)
        }
    }
}

struct ProgressModal_Previews: PreviewProvider {
    static var previews: some View {
        ProgressModal(showing: true)
    }
}
