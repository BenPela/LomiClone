//
//  HyperLinks.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-11-04.
//

import Foundation
import SwiftUI

/// This is a helper view to display text including hyper link. It is only for user ios 14. In ios 15, the Text view accept mark down.
struct HyperLinkText: View {
    // The current height of the view
    @State private var height: CGFloat = 0
    var content:  [ContentType<Text>]

    var body: some View {
        VStack {
            GeometryReader { geometry in
                // Needs to be .topLeading so we can modify alignments on top and leading
                if #available(iOS 15.0, *) {
                    ZStack(alignment: .topLeading) {
                        self.zStackViews(geometry)
                    }
                    .background {
                        calculateHeight($height)
                    }
                } else {
                    ZStack(alignment: .topLeading) {
                        self.zStackViews(geometry)
                    }
                    .background(calculateHeight($height))
                }
            }
        }.frame(height: height)
    }

    // Determine the alignment of every view in the ZStack
    func zStackViews(_ geometry: GeometryProxy) -> some View {
        // These are used to track the current horizontal and vertical position
        // in the ZStack. As a new text or link is added, horizontal is decreased.
        // When a new line is required, vertical is decreased & horizontal is reset to 0.
        var horizontal: CGFloat = 0
        var vertical: CGFloat = 0

        // Determine the alignment for the view at the given index
        func forEachView(_ index: Int) -> some View {
            let numberOfViewsInContent: Int
            let view: AnyView

            // Determine the number of views in the Content at the given index
            switch content[index] {
            case .text(let text):
                numberOfViewsInContent = text.count
                view = AnyView(text)
            case .link(let link):
                numberOfViewsInContent = 1
                view = AnyView(link)
            }

            var numberOfViewsRendered = 0

            // Note that these alignment guides can get called multiple times per view
            // since ContentText returns a ForEach
            return view
                .alignmentGuide(.leading, computeValue: { dimension in
                    numberOfViewsRendered += 1

                    let viewShouldBePlacedOnNextLine = geometry.size.width < -1 * (horizontal - dimension.width)
                    if viewShouldBePlacedOnNextLine {
                        // Push view to next line
                        vertical -= dimension.height
                        horizontal = -dimension.width
                        return 0
                    }

                    let result = horizontal

                    // Set horizontal to the end of the current view
                    horizontal -= dimension.width

                    return result
                })
                .alignmentGuide(.top, computeValue: { _ in
                    let result = vertical

                    // if this is the last view, reset everything
                    let isLastView = index == content.indices.last && numberOfViewsRendered == numberOfViewsInContent
                    if isLastView {
                        vertical = 0
                        horizontal = 0
                        numberOfViewsRendered = 0
                    }

                    return result
                })
        }

        return ForEach(0..<content.count, id: \.self, content: forEachView)
    }

    // Determine the height of the view containing our combined Text and Link views
    func calculateHeight(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geometry.frame(in: .local).height
            }

            return .clear
        }
    }
}

struct HyperLinkText_Previews: PreviewProvider {
    
    static func mockContent() -> [ContentType<Text>] {
        return [
            .text(ContentText("As with other views, you can style links using standard view modifiers depending on the view type of the link’s label. For example, a ")),
            .link(Link("Text", destination: URL(string: "https://developer.apple.com/documentation/swiftui/text")!)),
            .text(ContentText(" label could be modified with a custom ")),
            .link(Link("font(_:)", destination: URL(string: "https://developer.apple.com/documentation/swiftui/view/font(_:)")!)),
            .text(ContentText(" or ")),
            .link(Link("foregroundColor(_:)", destination: URL(string: "https://developer.apple.com/documentation/swiftui/view/foregroundcolor(_:)")!)),
            .text(ContentText(" to customize the appearance of the link in your app’s UI."))
        ]
    }
    
    static var previews: some View {
        HyperLinkText(content: mockContent())
    }
}

// View to split up a string into Text views, split by spaces.
struct ContentText: View {
    private var splitText: [String]
    let count: Int

    init(_ text: String) {
        self.splitText = text.split(separator: " ").map { "\($0) " }
        if text.hasPrefix(" ") {
            self.splitText = [" "] + self.splitText
        }

        self.count = splitText.count
    }

    var body: some View {
        ForEach(0..<self.splitText.count, id: \.self) { index in
            Text(splitText[index])
        }
    }
}

enum ContentType<T: View> {
    case text(ContentText)
    case link(Link<T>)
}
