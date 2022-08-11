//
//  CompostableMaterialsView.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-25.
//

import SwiftUI
import MarkdownUI

// A screen that presents information about the materials that are safe and unsafe to put in Lomi.
// Content is loaded from the "compostable-materials" API copy fragment.
struct MaterialsScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @State var showingLoading: Bool = true
    @State var lomiMaterials: [LomiMaterial] = []
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Do’s & Don’ts")
                            .font(.title)
                            .fontWeight(.semibold)

                        Text("Lomi loves all sorts of food and plant waste, and adding a diverse mixture in each cycle will give you the best dirt!")
                            .font(.callout)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.primarySoftBlack)
                    .padding(.bottom, 28)
                    
                    VStack {
                        ForEach(lomiMaterials) { lomiMaterial in
                            CollapsibleSection {
                                Text(lomiMaterial.title)
                                    .font(.headline)
                            } content: {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(lomiMaterial.subtitle)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Markdown(Document(stringLiteral: lomiMaterial.body))
                                        .markdownStyle(
                                            DefaultMarkdownStyle(
                                                font: .system(.body),
                                                foregroundColor: UIColor(.textDarkGrey)
                                            )
                                        )
                                        .padding(.leading, -16)
                                }
                            }
                        }
                    }.foregroundColor(.primarySoftBlack)

                }
                .padding()
            }
            
            
            ProgressModal(showing: showingLoading)
        }
        .onAppear(perform: {
            environment.lomiApi.getLomiMaterials(
                request: LomiMaterialsRequest(
                    bodyFormat: .markdown
                ),
                onSuccess:{
                    (response: LomiMaterialsResponse?) -> Void in
                    if let response = response {
                        lomiMaterials = response.lomiMaterials
                        showingLoading = false
                        AnalyticsLogger.singleton.logEvent(
                            .screenView,
                            parameters: [.screenName: AnalyticsScreenName.materials]
                        )
                    } else {
                        environment.handleError(error: "ApiError.EmptyBody".localized())
                    }
                },
                onError: {
                    (apiError: LomiApiErrorResponse) -> Void in
                    environment.handleApiErrorResponse(apiError: apiError)
                }
            )
        })
    }
}

struct CompostableMaterialsView_Previews: PreviewProvider {
    static var mocks = [
        LomiMaterial(
            position: 0,
            title: "Do's",
            subtitle: "Lomi loves these foods and plants.",
            body: "* Vegetables\n* Fruit\n* Animal Products\n* Soft Foods\n* Yard Waste"
        ),
        LomiMaterial(
            position: 1,
            title: "Limited",
            subtitle: "For best results, only add some of these in each cycle.",
            body: "* All Lomi approved products\n* Compostable cutlery\n* Compostable coffee cups\n* Compostable packaging\n* Single-use compostable plates\n* Other items marked “biodegradable” or “compostable”"
        ),
        LomiMaterial(
            position: 2,
            title: "Don'ts",
            subtitle: "These items should not go in Lomi.",
            body: "* Avocado seeds\n* Hard/large bones\n* Non-compostable dishware\n* Non-compostable cutlery\n* Other items not clearly marked as “biodegradeable or compostable”\n"
        ),
    ]
    
    static var previews: some View {
        MaterialsScreen(showingLoading: false, lomiMaterials: mocks)
            .environmentObject(PreviewAppEnvironmentBuilder().build())
    }
}
