//
//  UserViewModel.swift
//  03_W09_Notes
//
//  Created by Jeff Braun on 16.09.25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor
class UserViewModel: ObservableObject {
    private let auth = Auth.auth()
    private let database = Firestore.firestore()
    
    @Published var user: FireUser?
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
        fetchUserById(currentUser.uid)
    }
    
    func loginAnonymously() {
        print("🚀 Versuche anonyme Anmeldung...")
        Task {
            do {
                let result = try await auth.signInAnonymously()
                print("✅ Anonyme Anmeldung erfolgreich: \(result.user.uid)")
                createUser(
                    withId: result.user.uid,
                    email: "",
                    name: "",
                    birthDate: nil,
                    gender: nil,
                    job: nil
                )
                errorMessage = nil
            } catch {
                print("❌ Anonyme Anmeldung fehlgeschlagen: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func registerUser(
        name: String,
        birthDate: Date,
        gender: Gender,
        job: Job,
        email: String,
        password: String
    ) {
        print("🚀 Versuche Registrierung für: \(email)")
        errorMessage = nil
        Task {
            do {
                let result = try await auth.createUser(withEmail: email, password: password)
                print("✅ Registrierung erfolgreich: \(result.user.email ?? "No Email")")
                createUser(
                    withId: result.user.uid,
                    email: email,
                    name: name,
                    birthDate: birthDate,
                    gender: gender,
                    job: job
                )
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
                fetchUserById(result.user.uid)
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
    
    private func createUser(
        withId id: String,
        email: String,
        name: String?,
        birthDate: Date?,
        gender: Gender?,
        job: Job?
    ) {
        let user = FireUser(
            id: id,
            email: email,
            registeredOn: Date(),
            name: name,
            birthDate: birthDate,
            gender: gender,
            job: job
        )
        errorMessage = nil
        do {
            try database.collection("users").document(id).setData(from: user)
            fetchUserById(id)
        } catch {
            errorMessage = error.localizedDescription
            print(error)
        }
    }
    
    private func fetchUserById(_ id: String) {
        errorMessage = nil
        Task {
            do {
                let document = try await database.collection("users").document(id).getDocument()
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                errorMessage = error.localizedDescription
                print(error)
            }
        }
    }
}
