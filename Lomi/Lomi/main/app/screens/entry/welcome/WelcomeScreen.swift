//
//  WelcomeScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-14.
//

import SwiftUI

// A screen used to welcome the user. This is only displayed at first time app launch
struct WelcomeScreen: View {
    typealias Strings = WelcomeStrings
    
    var onComplete: () -> Void
    var onLogin: () -> Void
    
    init(onComplete: @escaping ()->Void, onLogin: @escaping ()->Void) {
        self.onComplete = onComplete
        self.onLogin = onLogin
    }
    
    var body: some View {
        ZStack() {
            VStack {

                VStack(alignment: .center, spacing: 16) {
                    Image(Strings.SourcePath.imageLogo)
                    Text(Strings.logoCatchphrase)
                        .font(CoreSans.headline)
                }
                .foregroundColor(.primaryIndigoGreen)
                .padding(.top, 48)
                
                Spacer()
                ButtonConfirm(text: Strings.signInButtonLabel, color: .primaryIndigoGreen, action: onComplete)
                    .padding(.horizontal)
                    .accessibilityIdentifier("\(Strings.signInButtonLabel)_BUTTON".identifierFormat())
                
                HStack {
                    Text(Strings.logInPrompt)
                        .font(.callout)
                        .foregroundColor(.primaryIndigoGreen)
                    
                    // TODO: Encapsulate the button with a new component after we get more direction from design.
                    Button(action: {
                        onLogin()
                    }){
                        Text(Strings.logInButtonLabel)
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryIndigoGreen)
                            .underline()
                            .accessibilityIdentifier("\(Strings.logInButtonLabel)_LINK_BUTTON".identifierFormat())
                    }

                }
                .padding(.top, 32)
                .padding(.bottom, 36)
            }
        }
        .background(
            Image(Strings.SourcePath.imageBackground)
                .resizable()
                // Fills the parent container with the image and cuts off parts of the image if necessary, with keeping aspect ratio
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .accessibilityHidden(true)
            , alignment: .top // This is to diplay the logo surely
        )
        .onAppear(perform: {
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.welcome]
            )
        })
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("WELCOME_SCREEN")
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(onComplete: {}, onLogin: {})
    }
}
