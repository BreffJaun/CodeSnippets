//
//  SnippetViewModel.swift
//  Code Snippets
//
//  Created by Jeff Braun on 18.09.25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor
class SnippetViewModel: ObservableObject {
    
    private let auth = FirebaseManager.shared.auth
    private let db = FirebaseManager.shared.database
    private var listenerRegistration: ListenerRegistration?
    
    @Published var snippet: FireSnippet?
    @Published var snippets: [FireSnippet] = []
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    init() {
        setupUserListener()
    }
    
    private func setupUserListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            if let _ = user {
                self.listenToSnippets()
            } else {
                self.removeListener()
            }
        }
    }
    
    func addSnippet(title: String, code: String, categoryId: String?) async {
            print("🚀 Attempting to add a new snippet...")
            
            guard let userId = FirebaseManager.shared.userId else {
                self.errorMessage = "User not logged in."
                print("❌ Error: User is not logged in. Cannot save snippet.")
                return
            }
            
            let snippet = FireSnippet(
                userId: userId,
                title: title,
                code: code,
                categoryId: categoryId
            )
            
            do {
                let _ = try db.collection(.snippets).addDocument(from: snippet)
                
                print("✅ Snippet successfully added.")
                self.successMessage = "Snippet successfully added!"
                self.errorMessage = nil
                
            } catch {
                print("❌ Error saving the snippet: \(error.localizedDescription)")
                self.errorMessage = "Error saving the snippet: \(error.localizedDescription)"
                self.successMessage = nil
            }
        }
    
    func deleteSnippet(snippet: FireSnippet) {
        guard let snippetId = snippet.id else { return }
        
        Task {
            do {
                try await db
                    .collection(.snippets)
                    .document(snippetId)
                    .delete()
                print("🔎 Snippet successfully deleted")
            } catch {
                print("Deletion failed: \(error.localizedDescription)")
            }
        }
    }
    
    // Listener Methods
    func listenToSnippets() {
        removeListener()
        print("🚀 Starting real-time listener for snippets.")
        guard let userId = FirebaseManager.shared.userId else {
            print("❌ Listener could not be started: User is not logged in.")
            return
        }
        
        print("👂 Listening for real-time updates for snippets from user ID: \(userId).")
        listenerRegistration = db.collection(.snippets)
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error {
                    print("❌ Error retrieving snippets: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("⚠️ No documents found in snapshot.")
                    return
                }
                
                let fetchedSnippets = documents.compactMap {
                    try? $0.data(as: FireSnippet.self)
                }
                
                if fetchedSnippets.isEmpty {
                    print("🔎 No snippets found for this user.")
                } else {
                    print("✅ \(fetchedSnippets.count) snippets successfully synchronized.")
                }
                
                self.snippets = fetchedSnippets
            }
    }
    
    func removeListener() {
        listenerRegistration?.remove()
        listenerRegistration = nil
        print("✅ Firestore listener removed.")
    }
    

    
}
