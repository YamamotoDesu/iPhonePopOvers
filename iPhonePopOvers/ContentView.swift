//
//  ContentView.swift
//  iPhonePopOvers
//
//  Created by 山本響 on 2023/03/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            Home()
                .navigationTitle("iOS Popovers")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
