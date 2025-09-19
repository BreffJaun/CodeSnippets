//
//  AuthView.swift
//  03_W09_Notes
//
//  Created by Jeff Braun on 16.09.25.
//

import SwiftUI

struct AuthView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    
    var body: some View {
        NavigationView {
            GradientBackground {
                VStack(spacing: 20) {
                    Picker("", selection: $isRegistering) {
                        Text("Login").tag(false)
                        Text("Registrieren").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom)
                    
                    if isRegistering {
                        RegisterView(email: $email, password: $password)
                    } else {
                        LoginView(email: $email, password: $password)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle(isRegistering ? "Authentication" : "Login")
                .toolbarBackground(.hidden, for: .navigationBar)
            }
        }
    }
}

//#Preview {
//    AuthView()
//}

