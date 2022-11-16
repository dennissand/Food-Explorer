//
//  ReviewViewModel.swift
//  Food Explorer
//
//  Created by Dennis Sand on 29.11.22.
//

import Foundation
import FirebaseFirestore

class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    
    func saveReview(spot: Spot, review: Review) async -> Bool {
        let db = Firestore.firestore()
        
        guard let spotID = spot.id else {
            print("ERROR: spot.id = nil")
                return false
        }
        let collectionString = "spots/\(spotID)/reviews"
        
        if let id = review.id {
            do {
                try await db.collection(collectionString).document(id).setData(review.dictionary)
                print("Data update successful !")
                return true
            } catch {
                print("ERROR: Could not update in 'reviews' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                _ = try await db.collection(collectionString).addDocument(data: review.dictionary)
                print("Data added successful !")
                return true
            } catch {
                print("ERROR: Could not create an new review in 'reviews' \(error.localizedDescription)")
                return false
            }
            
        }
    }
}
