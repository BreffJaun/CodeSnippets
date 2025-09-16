//
//  LoginView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 16.09.25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var email: String
    @Binding var password: String

    var body: some View {
        VStack(spacing: 16) {
            TextField("E-Mail", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            SecureField("Passwort", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            if let errorMessage = userViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                Task {
                    userViewModel.loginUser(email: email, password: password)
                }
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(email.isEmpty || password.isEmpty)
            
            Button(action: {
                userViewModel.loginAnonymously()
            }) {
                Text("Anonym anmelden")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
        }
    }
}


//#Preview {
//    LoginView()
//}
