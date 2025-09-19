//
//  FirestoreExtension.swift
//  Code Snippets
//
//  Created by Jeff Braun on 19.09.25.
//

import FirebaseFirestore

extension Firestore {
    func collection(_ type: FirestoreCollections) -> CollectionReference {
        self.collection(type.rawValue)
    }
}

// IN CASE OF USING SUBCOLLECTIONS, ADD THIS
//extension CollectionReference {
//    func document(_ id: String, subcollection: FirestoreCollections) -> CollectionReference {
//        self.document(id).collection(subcollection.rawValue)
//    }
//}

// AND USE THIS IN VIEWMODELS
//db.collection(.users)
//    .document(userId)
//    .collection(.snippets)
//    .addDocument(data: ...)
