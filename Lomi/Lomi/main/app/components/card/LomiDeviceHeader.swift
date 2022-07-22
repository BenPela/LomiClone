//
//  LomiDeviceHeader.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-02-01.
//

import SwiftUI

struct LomiDeviceHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add a Lomi")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Thank you for making garbage optional! Look for the serial number on the bottom of your Lomi to register for your warranty.")
                .font(.subheadline)
                .fontWeight(.medium)
                .lineSpacing(4)
                .foregroundColor(.textDarkGrey)
        }
    }
}

struct LomiDeviceHeader_Previews: PreviewProvider {
    static var previews: some View {
        LomiDeviceHeader()
    }
}
