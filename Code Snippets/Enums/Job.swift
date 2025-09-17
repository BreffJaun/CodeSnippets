//
//  Job.swift
//  Code Snippets
//
//  Created by Jeff Braun on 17.09.25.
//

import Foundation

enum Job: String, Codable, CaseIterable, Identifiable {
    case student = "Student"
    case employee = "Angestellter"
    case selfEmployed = "Selbstständig"
    case unemployed = "Arbeitslos"
    
    var id: String { self.rawValue }
}
