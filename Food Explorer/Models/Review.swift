//
//  Review.swift
//  Food Explorer
//
//  Created by Dennis Sand on 29.11.22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

struct Review: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    
    var title = ""
    var body = ""
    var rating = 0
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["title": title, "body": body, "rating": rating,
                "reviewer": reviewer, "postedOn": Timestamp(date: Date())]
    }
}
