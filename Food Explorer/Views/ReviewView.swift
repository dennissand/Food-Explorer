//
//  ReviewView.swift
//  Food Explorer
//
//  Created by Dennis Sand on 29.11.22.
//

import SwiftUI

struct ReviewView: View {
    @State var spot: Spot
    @State var review: Review
    @StateObject var reviewVM = ReviewViewModel()
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                Text (spot.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                
                Text (spot.address)
                    .padding(.bottom)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text ("Bewertung:")
                .font(.title2)
                .bold()
            HStack {
                StarsSelectionView(rating: $review.rating)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5),lineWidth: 2)
                    }
            }
            .padding(.bottom)
            
            VStack (alignment: .leading) {
                Text("Bewertungsüberschrift:")
                    .bold()
                    .font(.title2)
                
                TextField ("Überschrift", text: $review.title)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                
                Text("Bewertung:")
                    .bold()
                    .font(.title2)
                
                TextField ("Bewertung", text: $review.body, axis: .vertical)
                    .padding(.horizontal, 6)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                
            }
            .padding(.horizontal)
            
            
            Spacer()
        }
        
        
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Abbrechen") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Speichern") {
                    Task {
                        let success = await reviewVM.saveReview(spot: spot, review: review)
                        if success {
                            dismiss()
                        } else {
                            print("ERROR: saving data in ReviewView")
                            
                        }
                        
                    }
                }
            }
        }
    }
    struct ReviewView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                ReviewView(spot: Spot(name: "Golden Pig", address: "49 Boleston St., Chestnut Hill, MA 02467"), review: Review())
            }
        }
    }
}
