//
//  SpotViewModel.swift
//  Food Explorer
//
//  Created by Dennis Sand on 15.11.22.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor

class SpotViewModel: ObservableObject {
    @Published var spot = Spot()
    
    func saveSpot(spot: Spot) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = spot.id {
            do {
                try await db.collection("spots").document(id).setData(spot.dictionary)
                print("Spot update successful !")
                return true
            } catch {
                print("ERROR: Could not update spot in 'spots' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                let documentRef = try await db.collection("spots").addDocument(data: spot.dictionary)
                self.spot = spot
                self.spot.id = documentRef.documentID
                print("New Spot added successful !")
                return true
            } catch {
                print("ERROR: Could not create an new spot in 'spots' \(error.localizedDescription)")
                return false
            }
            
        }
    }
}
