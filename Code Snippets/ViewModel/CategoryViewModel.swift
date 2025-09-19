//
//  CategoryViewModel.swift
//  Code Snippets
//
//  Created by Jeff Braun on 19.09.25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor
class CategoryViewModel: ObservableObject {
    
    private let db = FirebaseManager.shared.database
    private let auth = FirebaseManager.shared.auth
    private var listenerRegistration: ListenerRegistration?

    @Published var categories: [FireCategory] = []
    @Published var errorMessage: String?

    init() {
        setupUserListener()
    }
    
    private func setupUserListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if user != nil {
                self.listenToCategories()
            } else {
                self.removeListener()
            }
        }
    }
    
    func addCategory(title: String) {
        guard let userId = FirebaseManager.shared.userId else {
            self.errorMessage = "User not logged in."
            return
        }
        
        let category = FireCategory(userId: userId, title: title)
        
        do {
            try db.collection(.categories).addDocument(from: category)
            print("✅ Category successfully added: \(title)")
            self.errorMessage = nil
        } catch {
            print("❌ Error adding category: \(error.localizedDescription)")
            self.errorMessage = "Error adding category: \(error.localizedDescription)"
        }
    }
    
    func deleteCategory(category: FireCategory) {
        guard let categoryId = category.id else { return }
        
        db.collection(.categories).document(categoryId).delete { error in
            if let error = error {
                print("❌ Error deleting category: \(error.localizedDescription)")
            } else {
                print("✅ Category successfully deleted.")
            }
        }
    }
    
    private func listenToCategories() {
        removeListener()
        guard let userId = FirebaseManager.shared.userId else {
            self.categories = []
            return
        }
        
        listenerRegistration = db.collection(.categories)
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error {
                    print("❌ Error retrieving categories: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                self.categories = documents.compactMap { try? $0.data(as: FireCategory.self) }
                print("✅ \(self.categories.count) categories synchronized.")
            }
    }
    
    func removeListener() {
        listenerRegistration?.remove()
        listenerRegistration = nil
        self.categories = []
        print("✅ Category listener removed.")
    }
}
