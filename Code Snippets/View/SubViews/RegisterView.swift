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
    
    @State private var name: String = ""
    @State private var birthDate: Date = Date()
    @State private var gender: Gender = .male
    @State private var job: Job = .student

    var body: some View {
        VStack(spacing: 16) {
            TextField("Name", text: $name)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            DatePicker("Geburtsdatum", selection: $birthDate, displayedComponents: .date)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Geschlecht")
                        .font(.caption)
                    
                    Picker("Geschlecht", selection: $gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 8)  {
                    Text("Beruf")
                        .font(.caption)
                    
                    Picker("Beruf", selection: $job) {
                        ForEach(Job.allCases) { job in
                            Text(job.rawValue).tag(job)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .frame(maxWidth: .infinity)
                
            }
            .frame(maxWidth: .infinity)

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
                    userViewModel.registerUser(
                        name: name,
                        birthDate: birthDate,
                        gender: gender,
                        job: job,
                        email: email,
                        password: password
                    )
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
