//
//  Home.swift
//  iPhonePopOvers
//
//  Created by 山本響 on 2023/03/27.
//

import SwiftUI

struct Home: View {
    /// - View Properties
    @State private var showPopover: Bool = false
    @State private var updateText: Bool = false
    var body: some View {
        Button("Show Popover") {
            showPopover.toggle()
        }
        .iOSPopover(isPresented: $showPopover, arrowDirection: .down) {
            VStack(spacing: 12) {
                Text("Hello, it is me. \(updateText ? "Updated Popover" : "Popover").")
                    .padding(15)
                Button("Update Text") {
                    updateText.toggle()
                }
                Button("Close Text") {
                    showPopover.toggle()
                }
            }
            .foregroundColor(.white)
            .padding(15)
            .frame(width: 250)
            /// - You can also Give Full Popover Color like this
            .background {
                Rectangle()
                    .fill(.blue.gradient)
                    .padding(-20)
            }
        }
//        .popover(isPresented: $showPopover) {
//            Text("Hello. It is Kyo.")
//        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
