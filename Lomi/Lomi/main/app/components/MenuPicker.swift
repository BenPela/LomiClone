//
//  MenuPicker.swift
//  CustomPicker
//
//  Created by Takayuki Yamaguchi on 2021-12-21.
//

import Foundation
import SwiftUI

struct MenuPicker<SelectionValue, Item>: View where Item: Identifiable, Item.ID == SelectionValue {
    
    var mainTitle: String
    /// This id will be updated to the item's id that you select.
    @Binding var selectedId: SelectionValue
    /// KeyPath for title that will be used in pull down menu
    var titleKeyPath: WritableKeyPath<Item, String>
    /// Source which has id (Identifiable).
    var items: [Item]
    
    @State var showItems: Bool = false
    let cellHPadding: CGFloat = 25
    let cellVPadding: CGFloat = 20
    var mainCellHeight: CGFloat {
        UIFont.preferredFont(forTextStyle: .callout).pointSize*1.24 + cellVPadding*2
    }
    var pullDownCellHeight: CGFloat {
        UIFont.preferredFont(forTextStyle: .callout).pointSize*1.24 + cellVPadding*1.5
    }
    let pickerRadius: CGFloat = 6
    func getMainCellTitle(_ item: Item) -> String {
        item[keyPath: titleKeyPath]
    }
    
    var body: some View {
        // Main
        Button {
            withAnimation(.easeInOut.speed(2)) {
                showItems.toggle()
            }
        } label: {
            mainMenu
        }
        .background(Color.primaryWhite)
        .cornerRadius(pickerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: pickerRadius)
                .strokeBorder(Color.secondaryGrey, lineWidth: 1)
        )
        // Pull down.
        .overlay(pullDownMenu, alignment: .top)
        .shadow(color: .black.opacity(showItems ? 0.1 : 0), radius: 5, x: 0, y: 2)
        .zIndex(999)
    }
}


// MARK: - Subviews

extension MenuPicker {
    
    var mainMenu: some View {
        HStack {
            Text(mainTitle)
                .font(.subheadline)
                .lineLimit(1)
            
            Spacer()
            
            Image(systemName: showItems ? "chevron.up" : "chevron.down")
                .font(.subheadline)
        }
        .foregroundColor(.primarySoftBlack)
        .padding(.horizontal, cellHPadding)
        .padding(.vertical, cellVPadding)
    }
    
    var pullDownMenu: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(items) { item in
                    Button(action: {
                        selectedId = item.id
                        showItems = false
                    }, label: {
                        Group {
                            HStack {
                                Text(getMainCellTitle(item))
                                    .foregroundColor(.primarySoftBlack)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                Spacer()
                            }
                            .padding(.horizontal, cellHPadding/2)
                            .padding(.vertical, cellVPadding/2)
                            .background( item.id == selectedId ? Color.secondaryGreenShade : Color.primaryWhite )
                        }
                        .cornerRadius(3)
                        .padding(.horizontal, cellHPadding/2)
                        .padding(.vertical, cellVPadding/4)
                    })
                }
            }.padding(.top, 8)
        }
        .background(Color.primaryWhite)
        .cornerRadius(pickerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: pickerRadius)
                .strokeBorder(Color.gray, lineWidth: 1)
        )
        .offset(x: 0, y: mainCellHeight)
        // The pull down hight will be at most creen height*0.6
        .frame(height: showItems ? min(pullDownCellHeight*CGFloat(items.count)+12, UIScreen.main.bounds.height*0.6) : 0)
    }
}


// MARK: - Previews

struct MenuPicker_Previews: PreviewProvider {
    
    struct MockItem: Identifiable {
        let uuid = UUID()
        var title: String
        var id: String { return self.uuid.uuidString }
    }
    
    struct MockContentView: View {
        @State  var selectedId: String = ""
        let items = (0...5).map { MockItem(title: "No. \($0)") }
        private var selectedItem: MockItem? {
            items.first(where: { $0.id.description == selectedId})
        }
        var body: some View {
            VStack {
                Text("View")
                MenuPicker(
                    mainTitle: selectedItem?.title ?? "Not selected",
                    selectedId: $selectedId,
                    titleKeyPath: \MockItem.title,
                    items: items
                )
                Text("View")
                Text("\(selectedItem?.title ?? "Nothing") is selected")
                Spacer()
            }
        }
    }
    
    static var previews: some View {
        MockContentView()
            .padding()
    }
}

