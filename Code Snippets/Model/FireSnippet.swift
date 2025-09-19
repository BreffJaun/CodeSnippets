//
//  FireSnippet.swift
//  Code Snippets
//
//  Created by Jeff Braun on 18.09.25.
//

import Foundation
import FirebaseFirestore

struct FireSnippet: Codable, Identifiable {
    @DocumentID var id: String?
    
    var userId: String
    var title: String
    var code: String
}
