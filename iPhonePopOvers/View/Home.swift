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
    var body: some View {
        Button("Show Popover") {
            showPopover.toggle()
        }
        .iOSPopover(isPresented: $showPopover, arrowDirection: .up) {
            Text("Hello, it is me, Popover.")
                .padding(15)
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
