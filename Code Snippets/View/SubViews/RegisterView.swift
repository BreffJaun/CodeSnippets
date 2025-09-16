//
//  RegisterView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 16.09.25.
//

import SwiftUI

struct RegisterView: View {
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
                    userViewModel.registerUser(email: email, password: password)
                }
            }) {
                Text("Registrieren")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
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
//    RegisterView()
//}
