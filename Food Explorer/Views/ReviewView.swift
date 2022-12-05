//
//  ReviewView.swift
//  Food Explorer
//
//  Created by Dennis Sand on 29.11.22.
//

import SwiftUI
import Firebase

struct ReviewView: View {
    @StateObject var reviewVM = ReviewViewModel()
    @State var spot: Spot
    @State var review: Review
    @State var postedByThisUser = false
    @State var rateOrReviewerString = "Vergib Sterne" // otherwise will say poster e-mail & date
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
            
            Text (rateOrReviewerString)
                .font(postedByThisUser ? .title2 : .subheadline)
                .bold(postedByThisUser)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal)
            
            
            
            HStack {
                StarsSelectionView(rating: $review.rating)
                    .disabled(!postedByThisUser)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5),lineWidth: postedByThisUser ? 2 : 0.3)
                    }
            }
            .padding(.bottom)
            
            VStack (alignment: .leading) {
                Text("Bewertungstitel:")
                    .bold()
                    
                
                TextField ("Titel", text: $review.title)
                    .padding(.horizontal, 6)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                    }
                
                Text("Bewertung:")
                    .bold()
                    .font(.title2)
                
                TextField ("Bewertung", text: $review.body, axis: .vertical)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                    }
                
            }
            .disabled(!postedByThisUser)
            .padding(.horizontal)
            .font(.title2)
            
            
            Spacer()
        }
        .onAppear{
            if review.reviewer == Auth.auth().currentUser?.email {
                postedByThisUser = true
            } else {
                let reviewPostedOn = review.postedOn.formatted(date: .numeric, time: .omitted)
                rateOrReviewerString = "von: \(review.reviewer) am: \(reviewPostedOn)"
            }
        }
        .navigationBarBackButtonHidden(postedByThisUser)
        .toolbar {
            if postedByThisUser {
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
        }
    }
    struct ReviewView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                ReviewView(spot: Spot(name: "Golden Pig", address: "49 Boleston St., Chestnut Hill, MA 02467"), review: Review())
            }
        }
    }

