//
//  TipView.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-03.
//

import SwiftUI
import MarkdownUI

struct TipScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    
    var tipId: String
    @State var loading: Bool = true
    @State var tip: Tip? = nil
    
    var body: some View {
        ZStack {
            if let tip = tip {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(tip.title)
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.bottom, 10)
                        
                        if let dateString = DateTimeHelper.getMonthDayYearString(isoDateString: tip.createdAt) {
                            Text("Published \(dateString)")
                                .foregroundColor(.secondaryGrey)
                                .font(.caption2)
                                .padding(.bottom)
                        }
                        
                        RemoteImage(url: tip.image.url)
                            .padding(.bottom)
                        
                        if let body = tip.body {
                            Markdown(Document(stringLiteral: body))
                                .padding(.bottom)
                        }
                        
                        if let linkText = tip.linkText, let linkUrl = tip.linkUrl {
                            if !linkUrl.isEmpty && !linkText.isEmpty {
                                if let url = URL(string: linkUrl) {
                                    ButtonLink(
                                        text: linkText,
                                        textSize: 14,
                                        action: {
                                            AnalyticsLogger.singleton.logEvent(
                                                .openUrl,
                                                parameters: [
                                                    .screenName: AnalyticsScreenName.tip,
                                                    .itemID: tip.id,
                                                    .itemName: tip.title,
                                                    .linkURL: linkUrl,
                                            ])
                                            UIApplication.shared.open(url)
                                        }
                                    )
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                    }
                    .padding(.all, 24)
                }
                
                Spacer()
            }
            
            ProgressModal(showing: loading)
        }
        .onAppear(perform: {
            // getTips only gets summaries, so we need to fetch the body of individual tips
            let tipsService = environment.serviceLocator.resolveService(TipsService.self)
            loading = true
            // FIXME: this could be in a viewController, but minimizing refactor until we redo articles for 2.0
            Task {
                let response = await tipsService?.getTip(id: tipId)
                loading = false
                if let foundTip = response {
                    tip = foundTip
                    AnalyticsLogger.singleton.logEvent(
                        .screenView,
                        parameters: [
                            .screenName: AnalyticsScreenName.tip,
                            .itemID: foundTip.id,
                            .itemName: foundTip.title,
                        ]
                    )
                } else {
                    environment.handleError(error: "Error: article not found (\(tipId))")
                }
            }
        })
    }
}

struct TipScreen_Previews: PreviewProvider {
    private static let mockTip = Tip(
        id: "mockTipId",
        createdAt: "2021-09-03T20:08:38.812Z",
        title: "You should try this tip",
        image: ApiImage(url: "https://www.datocms-assets.com/48473/1628612317-tip-test-image-1.jpeg"),
        bookmarked: false,
        body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque cursus lectus ornare imperdiet ante. Viverra a semper purus auctor ut ac, vitae at duis. Amet ullamcorper leo nisi egestas tortor vestibulum. Pharetra tempor placerat accumsan nunc, nisi, ipsum netus est. Eu sed in malesuada vel tortor, diam at. Risus sit accumsan mi urna arcu. Ullamcorper diam vitae, enim, vitae.",
        linkText: nil,
        linkUrl: nil
    )
    
    static var previews: some View {
        let environment = PreviewAppEnvironmentBuilder().build()
        TipScreen(tipId: "mockTipId",loading: false, tip: mockTip)
            .environmentObject(environment)
    }
}
