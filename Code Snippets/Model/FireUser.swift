//
//  FireUser.swift
//  03_W09_Notes
//
//  Created by Jeff Braun on 17.09.25.
//

import Foundation
import FirebaseFirestore

struct FireUser: Codable, Identifiable {
    @DocumentID var id: String?
    var email: String
    var registeredOn: Date
    
    var name: String?
    var birthDate: Date?
    var gender: Gender?
    var job: Job?
}
