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
    
    private let auth = FirebaseManager.shared.auth
    private let db = FirebaseManager.shared.database
    
    
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
            print("🔍 No user logged in")
            return
        }
        print("🔍 User found: \(currentUser.email ?? "Anonymous")")
        fetchUserById(currentUser.uid)
    }
    
    func loginAnonymously() {
        print("🚀 Attempting anonymous login...")
        Task {
            do {
                let result = try await auth.signInAnonymously()
                print("✅ Anonymous login successful: \(result.user.uid)")
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
                print("❌ Anonymous login failed: \(error.localizedDescription)")
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
        print("🚀 Attempting registration for: \(email)")
        errorMessage = nil
        Task {
            do {
                let result = try await auth.createUser(withEmail: email, password: password)
                print("✅ Registration successful: \(result.user.email ?? "No Email")")
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
                print("❌ Registration failed: \(error)")
                if let authError = error as NSError? {
                    print("❌ Auth Error Code: \(authError.code)")
                    print("❌ Auth Error Domain: \(authError.domain)")
                }
                errorMessage = "Registration failed: \(error.localizedDescription)"
            }
        }
    }
    
    func loginUser(email: String, password: String) {
        print("🚀 Attempting login for: \(email)")
        errorMessage = nil
        Task {
            do {
                let result = try await auth.signIn(withEmail: email, password: password)
                print("✅ Login successful: \(result.user.email ?? "No Email")")
                fetchUserById(result.user.uid)
                errorMessage = nil
            } catch {
                print("❌ Login failed: \(error)")
                if let authError = error as NSError? {
                    print("❌ Auth Error Code: \(authError.code)")
                    print("❌ Auth Error Domain: \(authError.domain)")
                }
                errorMessage = "Login failed: \(error.localizedDescription)"
            }
        }
    }
    
    func logout() {
        print("🚀 Attempting logout...")
        do {
            try auth.signOut()
            print("✅ Logout successful")
            user = nil
            errorMessage = nil
        } catch {
            print("❌ Logout failed: \(error)")
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
            try db.collection(.users).document(id).setData(from: user)
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
                let document = try await db.collection(.users).document(id).getDocument()
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                errorMessage = error.localizedDescription
                print(error)
            }
        }
    }
}


