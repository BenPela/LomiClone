//
//  UserDetailsScreen.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-08.
//

import SwiftUI

// A screen that presents details regarding the current user.
struct UserDetailsScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    
    var body: some View {
        ZStack {
            if let user = environment.currentUser {
                VStack {
                    Text("Account details")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading) 

                    
                    EditableCell(
                        destination: {
                            EditUserFirstNameScreen()
                        },
                        label: "First name",
                        text: user.firstName
                    )
                    
                    EditableCell(
                        destination: {
                            EditUserLastNameScreen()
                        },
                        label: "Last name",
                        text: user.lastName
                    )
                    
                    EditableCell(
                        destination: {
                            EditUserEmailScreen()
                        },
                        label: "Email",
                        text: user.email
                    )
                    
                    EditableCell(
                        destination: {
                            ResetPasswordScreen()
                        },
                        label: "Password",
                        text: "*************"
                    )
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        WebNavigationLink(url: LomiWebLink.deactivate.rawValue) {
                            Text("Deactivate account")
                                .font(.footnote)
                                .foregroundColor(.secondaryGrey)
                                .underline()
                        }
                        Spacer()
                    }
                    .padding(.bottom, 36)
                }
                .padding()
                .onAppear(perform: {
                    AnalyticsLogger.singleton.logEvent(
                        .screenView,
                        parameters: [.screenName: AnalyticsScreenName.userDetails]
                    )
                })
            }
        }

    }
}

struct UserDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsScreen()
            .environmentObject(
                PreviewAppEnvironmentBuilder()
                    .withLomiApiAuthRepository(authRepository: PreviewLomiApiAuthRepository.mockAuthRepository)
                    .build())
    }
}
