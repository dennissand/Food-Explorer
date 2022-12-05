//
//  SpotReviewRowView.swift
//  Food Explorer
//
//  Created by Dennis Sand on 03.12.22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SpotReviewRowView: View {
    @State var review: Review
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(review.title)
                .font(.title2)
            HStack{
                StarsSelectionView(rating: $review.rating, interactive: false, font: .callout)
                Text(review.body)
                    .font(.callout)
                    .lineLimit(1)
            }
        }
    }
}

struct SpotReviewRowView_Previews: PreviewProvider {
    static var previews: some View {
        SpotReviewRowView(review: Review(title:"Beste Essen der Welt", body: "Beste Pommes der Welt und sollte man immer besuchen", rating: 3))
    }
}
