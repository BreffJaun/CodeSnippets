//
//  UserViewModel.swift
//  03_W09_Notes
//
//  Created by Jeff Braun on 16.09.25.
//

import Foundation
import Firebase
import FirebaseAuth

@MainActor
class UserViewModel: ObservableObject {
    
    private let auth = Auth.auth()
    
    @Published var user: User?
    @Published var errorMessage: String?
    
    var isUserLoggedIn: Bool {
        user != nil
    }
    
    init() {
        checkAuth()
    }
    
    private func checkAuth() {
        guard let currentUser = auth.currentUser else {
            print("🔍 Kein User angemeldet")
            return
        }
        print("🔍 User gefunden: \(currentUser.email ?? "Anonymous")")
        user = currentUser
    }
    
    func loginAnonymously() {
        print("🚀 Versuche anonyme Anmeldung...")
        Task {
            do {
                let result = try await auth.signInAnonymously()
                print("✅ Anonyme Anmeldung erfolgreich: \(result.user.uid)")
                user = result.user
                errorMessage = nil
            } catch {
                print("❌ Anonyme Anmeldung fehlgeschlagen: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func registerUser(email: String, password: String) {
        print("🚀 Versuche Registrierung für: \(email)")
        errorMessage = nil
        Task {
            do {
                let result = try await auth.createUser(withEmail: email, password: password)
                print("✅ Registrierung erfolgreich: \(result.user.email ?? "No Email")")
                user = result.user
                errorMessage = nil
            } catch {
                print("❌ Registrierung fehlgeschlagen: \(error)")
                if let authError = error as NSError? {
                    print("❌ Auth Error Code: \(authError.code)")
                    print("❌ Auth Error Domain: \(authError.domain)")
                }
                errorMessage = "Registrierung fehlgeschlagen: \(error.localizedDescription)"
            }
        }
    }
    
    func loginUser(email: String, password: String) {
        print("🚀 Versuche Login für: \(email)")
        errorMessage = nil
        Task {
            do {
                let result = try await auth.signIn(withEmail: email, password: password)
                print("✅ Login erfolgreich: \(result.user.email ?? "No Email")")
                user = result.user
                errorMessage = nil
            } catch {
                print("❌ Login fehlgeschlagen: \(error)")
                if let authError = error as NSError? {
                    print("❌ Auth Error Code: \(authError.code)")
                    print("❌ Auth Error Domain: \(authError.domain)")
                }
                errorMessage = "Login fehlgeschlagen: \(error.localizedDescription)"
            }
        }
    }
    
    func logout() {
        print("🚀 Versuche Logout...")
        do {
            try auth.signOut()
            print("✅ Logout erfolgreich")
            user = nil
            errorMessage = nil
        } catch {
            print("❌ Logout fehlgeschlagen: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}
