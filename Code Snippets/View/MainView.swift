//
//  MainView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 16.09.25.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        if userViewModel.isUserLoggedIn {
            TabBarView()
        } else {
            AuthView()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(UserViewModel())
}
