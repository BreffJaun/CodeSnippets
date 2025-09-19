//
//  FirebaseManager.swift
//  Code Snippets
//
//  Created by Jeff Braun on 18.09.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    let auth = Auth.auth()
    let database = Firestore.firestore()
    
    static var shared: FirebaseManager {
        if instance == nil {
            instance = FirebaseManager()
        }
        return instance!
    }
    static private var instance: FirebaseManager?
    
    private init() {}
    
    var userId: String? {
        auth.currentUser?.uid
    }
}
