//
//  ConfirmEmail.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-17.
//

import SwiftUI

struct ConfirmEmailScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    var onNext: () -> Void
    var onResendEmail: () -> Void
    var email: String?
    private var emailFormatted: String {
        guard let email = email else { return ""}
        return "\(email)"
    }
    
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Image("emailVerificationTop")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                    .padding(.bottom)
                
                Text("Please check your email")
                    .font(CoreSans.title)
                    .foregroundColor(.primaryIndigoGreen)
                    .padding(.top)
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text(verbatim: "Be proud, you’re well on your way to making a difference!")
                        .foregroundColor(Color(.darkGray))
                        .padding(.vertical, 8)
                    
                    Text("We’ve sent an email to \(emailFormatted). Check now to confirm it’s you and start turning waste into dirt!")
                        .foregroundColor(Color(.darkGray))
                        .padding(.vertical, 8)
                }
                
                Spacer()
                
                ButtonConfirm(
                    text: "I’ve confirmed my email",
                    disabled: false,
                    action: {
                        onNext()
                    }
                )
                .padding(.bottom)
                
                ButtonLink(
                    text: "Resend verification email",
                    action: {
                        guard let email = email else { return }
                        isLoading = true
                        environment.lomiApi.resendEmailVerification(
                            request: ResendEmailVerificationRequest(email: email),
                            onSuccess: { _ in
                                // TODO: Add analytics to resend email if exist.
                                isLoading = false
                                onResendEmail()
                            },
                            onError: { (apiError: LomiApiErrorResponse) -> Void in
                                isLoading = false
                                onResendEmail()
                                environment.handleApiErrorResponse(apiError: apiError)
                            }
                        )
                    }
                )
            
                Spacer()
                
            }
            .padding()
            
            ProgressModal(showing: isLoading)
        }
        .onAppear(perform: {
            AnalyticsLogger.singleton.logEvent(
                .screenView,
                parameters: [.screenName: AnalyticsScreenName.confirmEmail]
            )
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""), displayMode: .inline)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("CONFIRM_EMAIL_SCREEN")
    }
}

struct UserEmailVerification_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConfirmEmailScreen(
                onNext: {},
                onResendEmail: {}
            )
        }
    }
}
