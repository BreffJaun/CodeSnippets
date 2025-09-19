//
//  MainView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 16.09.25.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var userViewModel = UserViewModel()
    @StateObject var snippetViewModel = SnippetViewModel()
    @StateObject var categoryViewModel = CategoryViewModel()
    
    var body: some View {
        if userViewModel.isUserLoggedIn {
            TabBarView()
                .environmentObject(userViewModel)
                .environmentObject(snippetViewModel)
                .environmentObject(categoryViewModel)
        } else {
            AuthView()
                .environmentObject(userViewModel)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(UserViewModel())
        .environmentObject(SnippetViewModel())
        .environmentObject(CategoryViewModel())
}
