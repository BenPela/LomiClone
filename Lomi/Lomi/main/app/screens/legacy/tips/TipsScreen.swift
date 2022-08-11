//
//  TipsView.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-03.
//

import SwiftUI

// A screen that allows the user to browse "Tips".  The user can view all Tips or
struct TipsScreen: View {
    
    @EnvironmentObject var environment: AppEnvironment
    @State var loading: Bool = false

    // FIXME: this function could be in a viewController, but minimizing refactor until we redo articles for 2.0
    func fetchTipsIfNeeded() {
        // Avoid re-fetching
        if environment.recentTipSummaries.count > 0 { return }
        let tipsService = environment.serviceLocator.resolveService(TipsService.self)
        loading = true
        Task {
            let response = await tipsService?.getTips()
            loading = false
            if let tips = response {
                environment.recentTipSummaries = tips
            } else {
                environment.handleError(error: "ApiError.EmptyBody".localized())
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Reading")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 24)
                
                Text("Passionate about reducing waste? Read up on how to get the best results from your Lomi, general composting tips and more! ")
                
                TipsCell(tips: environment.recentTipSummaries)
                    .frame(maxWidth: .infinity)
                
                Spacer(minLength: 0)
            }
            .padding(.top)
            .padding(.horizontal)
            
            ProgressModal(showing: loading)
        }
        .navigationBarTitle("Reading")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .onAppear {
            fetchTipsIfNeeded()
        }
    }
}

// FIXME: new pattern for preview with Services instead of LomiApi
struct TipsScreen_Previews: PreviewProvider {
    class TipsScreenPreviewLomiApi: PreviewLomiApi {
        override func getTips(authToken: String?, request: GetTipsRequest, onSuccess: @escaping (GetTipsResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
            onSuccess(GetTipsResponse(tips: [
                Tip(id: "tip-1",
                    createdAt: "2021-10-13T22:35:31.718Z",
                    title: "This is the First Tip",
                    image: ApiImage(url: "https://www.datocms-assets.com/48473/1628612317-tip-test-image-1.jpeg"),
                    bookmarked: true),
                Tip(id: "tip-2",
                    createdAt: "2021-07-08T22:35:31.718Z",
                    title: "This is the Second Tip",
                    image: ApiImage(url: "https://www.datocms-assets.com/48473/1628612349-tip-test-image-3.png"),
                    bookmarked: false),
            ]))
        }
    }
    
    static var previews: some View {
        let authRepository: LomiApiAuthRepository = PreviewLomiApiAuthRepository(
            initialAuth: LomiApiAuth(
                user: User(
                    id: "user-1",
                    firstName: "Chris",
                    lastName: "Worman",
                    email: "chris.worman@pelacase.com",
                    createdAt: "2021-10-13T22:35:31.718Z",
                    createdByApiClient: LomiApiClientDetails(name: "iOS", version: "1.0.0"),
                    metadata: [Metadata(key: "mockKey", value: "mockValue")]
                ),
                authToken: "lomi-auth-token"))
        
        TipsScreen()
            .environmentObject(
                PreviewAppEnvironmentBuilder()
                    .withLomiApi(lomiApi: TipsScreenPreviewLomiApi())
                    .withLomiApiAuthRepository(authRepository: authRepository)
                    .build()
            )
        
    }
}
