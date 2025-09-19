//
//  FireCategory.swift
//  Code Snippets
//
//  Created by Jeff Braun on 19.09.25.
//

import Foundation
import FirebaseFirestore

struct FireCategory: Codable, Identifiable {
    @DocumentID var id: String?
    let userId: String
    var title: String
}
