//
//  TabBarView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 16.09.25.
//

import Foundation
import SwiftUI

struct TabBarView: View {
    
    
    var body: some View {
        TabView {
            
            Tab("User", systemImage: "person.circle") {
                HomeView()
            }
            
            
            Tab("Code Snippets", systemImage: "c.circle") {

            }
        }
    }
}

//#Preview {
//    TabBarView()
//}
