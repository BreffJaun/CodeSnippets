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
    
    private let fieldHeight: CGFloat = 54
    
    var body: some View {
        
        VStack(spacing: 16) {
            TextField("Name", text: $name)
                .padding()
                .frame(height: fieldHeight)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            DatePicker("Geburtsdatum", selection: $birthDate, displayedComponents: .date)
                .padding()
                .frame(height: fieldHeight)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Geschlecht")
                        .font(.caption)
                    
                    Picker("", selection: $gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity)
                .frame(height: fieldHeight)
                
                VStack(alignment: .leading, spacing: 8)  {
                    Text("Beruf")
                        .font(.caption)
                    
                    Picker("", selection: $job) {
                        ForEach(Job.allCases) { job in
                            Text(job.rawValue).tag(job)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity)
                .frame(height: fieldHeight)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            
            TextField("E-Mail", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding()
                .frame(height: fieldHeight)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            SecureField("Passwort", text: $password)
                .padding()
                .frame(height: fieldHeight)
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
                    .frame(height: fieldHeight)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(email.isEmpty || password.isEmpty)
        }
    }
}

//#Preview {
//    RegisterView()
//}
