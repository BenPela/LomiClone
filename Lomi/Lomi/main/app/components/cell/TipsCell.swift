//
//  TipsListView.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-03.
//

import SwiftUI

// A vertically scrollable list of tips
struct TipsCell: View {
    
    var tips: Array<Tip>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                ForEach(tips) { tip in
                    NavigationLink {
                        TipScreen(tipId: tip.id)
                    } label: {
                        ZStack {
                            HStack(alignment: .center, spacing: 0) {
                                RemoteImage(url: tip.image.url, contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(16)
                                    .padding()
                                
                                VStack(alignment: .leading) {
                                    Text(tip.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primarySoftBlack)
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(3)
                                    Spacer()
                                    if let dateString = DateTimeHelper.getMonthDayYearString(isoDateString: tip.createdAt) {
                                        Text("Published \(dateString)")
                                            .foregroundColor(.secondaryGrey)
                                            .font(.caption2)
                                    }
                                }
                                .padding(.top, 24)
                                .padding(.bottom, 16)
                                Spacer()
                            }
                        }
                        .padding(.leading, 10)
                        .background(Color.inputFieldsOffWhite)
                        .cornerRadius(15)
                    }
                }
            }
            .padding(.top, 24)
        }
    }
}


struct TipsCell_Previews: PreviewProvider {
    static var previews: some View {
        TipsCell(
            tips: [
                Tip(
                    id: "tipSummary-1",
                    createdAt: "2021-09-03T20:08:38.812Z",
                    title: "You should try this tip",
                    image: ApiImage(url: "https://www.datocms-assets.com/48473/1628612317-tip-test-image-1.jpeg"),
                    bookmarked: true),
                Tip(
                    id: "tipSummary-2",
                    createdAt: "2020-08-03T20:08:38.812Z",
                    title: "Another tip with a longer title",
                    image: ApiImage(url: "https://www.datocms-assets.com/48473/1628612349-tip-test-image-3.png"),
                    bookmarked: false)
            ]
        )
    }
}
