//
//  ListView.swift
//  Food Explorer
//
//  Created by Dennis Sand on 14.11.22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListView: View {
    @FirestoreQuery(collectionPath: "spots") var spots: [Spot]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(spots) { spot in
                NavigationLink {
                    SpotDetailView(spot: spot)
                } label: {
                    Text(spot.name)
                        .font(.title2)
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Food Places")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Ausloggen") {
                        do {
                            try Auth.auth().signOut()
                            print("Ausloggen successful !")
                            dismiss()
                        } catch {
                            print("ERROR - could not Ausloggen ")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus" )
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    SpotDetailView(spot: Spot(), previewRunning: true)
                }
            }
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ListView()
            
        }
    }
}
