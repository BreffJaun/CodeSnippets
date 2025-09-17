//
//  Gender.swift
//  Code Snippets
//
//  Created by Jeff Braun on 17.09.25.
//

import Foundation

enum Gender: String, Codable, CaseIterable, Identifiable {
    case male = "Männlich"
    case female = "Weiblich"
    case diverse = "Divers"
    
    var id: String { self.rawValue }
}

