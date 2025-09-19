//
//  HomeView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 16.09.25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        GradientBackground {
            VStack(spacing: 20) {
                Text("Willkommen zu deiner App!")
                    .font(.title)
                    .bold()
                
                Button(action: {
                    userViewModel.logout()
                }) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .padding()
        }
    }
}

//#Preview {
//    HomeView()
//}
