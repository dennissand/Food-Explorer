//
//  SpotDetailView.swift
//  Food Explorer
//
//  Created by Dennis Sand on 15.11.22.
//
import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SpotDetailView: View {
    struct Annotation: Identifiable {
        let id = UUID().uuidString
        var name: String
        var address: String
        var coordinate: CLLocationCoordinate2D
    }
    
    @EnvironmentObject var spotVM: SpotViewModel
    @EnvironmentObject var locationManager: LocationManager
    @FirestoreQuery(collectionPath: "spots") var reviews: [Review]
    @State var spot: Spot
    @State private var showPlaceLookupSheet = false
    @State private var showReviewViewSheet = false
    @State private var showSaveAlert = false
    @State private var showingAsSheet = false
    @State private var mapRegion = MKCoordinateRegion()
    @State private var annotations: [Annotation] = []
    var avgRating: String {
        guard reviews.count != 0 else {
            return "0.0"
        }
        let averageValue = Double(reviews.reduce(0) {$0 + $1.rating}) /
        Double(reviews.count)
        return String(format: "%.1f", averageValue)
    }
    
    @Environment(\.dismiss) private var dismiss
    let regionSize = 500.0 // meters
    var previewRunning = false
    
    var body: some View {
        VStack {
            Group {
                TextField("Name", text: $spot.name)
                    .font(.title)
                TextField("Addresse", text: $spot.address)
                    .font(.title2)
            }
            .disabled(spot.id == nil ? false: true)
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: spot.id == nil ? 2 : 0)
            }
            .padding(.horizontal)
            
            Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: annotations) { annotation in
                MapMarker(coordinate: annotation.coordinate)
            }
            .frame(height: 250)
            .onChange(of: spot) { _ in
                annotations = [Annotation(name: spot.name, address: spot.address, coordinate: spot.coordinate)]
                mapRegion.center = spot.coordinate
            }
            
            List {
                Section {
                    ForEach(reviews) { review in
                        NavigationLink {
                            ReviewView(spot: spot, review: review)
                        } label: {
                            SpotReviewRowView(review: review)
                        }

                    }
                        
                    
                } header: {
                    HStack {
                        Text("Bewertung:")
                            .font(.title2)
                            .bold()
                        Text(avgRating)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(Color("FoodColor"))
                        Spacer()
                        Button ("Bewerten") {
                            if spot.id == nil {
                                showSaveAlert.toggle()
                            } else {
                                showReviewViewSheet.toggle()
                            }
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .bold()
                        .tint(Color("FoodColor"))
                        
                    }
                }
                .headerProminence(.increased)
            }
            .listStyle(.plain)
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            if !previewRunning && spot.id != nil {
                $reviews.path = "spots/\(spot.id ?? "")/reviews"
                print("reviews.path = \($reviews.path)")
            } else {
              showingAsSheet = true
            }
            
            if spot.id != nil {
                mapRegion = MKCoordinateRegion(center: spot.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
            } else {
                Task {
                    mapRegion = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: regionSize, longitudinalMeters: regionSize)
                }
            }
            annotations = [Annotation(name: spot.name, address: spot.address, coordinate: spot.coordinate)]
        }
        .navigationBarTitleDisplayMode(.inline)
        // if not saved - save and cancle option otherwise a back Option
        .navigationBarBackButtonHidden(spot.id == nil)
        .toolbar {
            if showingAsSheet {
                if spot.id == nil && showingAsSheet {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Abbrechen") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Speichern") {
                            Task {
                                let success = await spotVM.saveSpot(spot: spot)
                                if success {
                                    dismiss()
                                } else {
                                    print("ERROR saving spot!")
                                }
                            }
                            
                            dismiss()
                        }
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        
                        Button {
                            showPlaceLookupSheet.toggle()
                        } label: {
                            Image(systemName: "magnifyingglass")
                            Text("Food Place finden")
                        }
                        
                    }
                } else if showingAsSheet && spot.id != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button ("Fertig") {
                            dismiss()
                        
                        }

                    }
                }
            
            }
        }
        .sheet(isPresented: $showPlaceLookupSheet) {
            PlaceLookupView(spot: $spot)
        }
        .sheet(isPresented: $showReviewViewSheet) {
            NavigationStack {
                ReviewView(spot: spot, review: Review())
            }
        }
        .alert("Kann nicht bewertet werden bevor Foodplace gespeichert ist", isPresented: $showSaveAlert) {
            Button("Abbrechen", role: .cancel) {}
            Button("Speichern", role: .none) {
                Task {
                    let success = await spotVM.saveSpot(spot: spot)
                    spot = spotVM.spot
                    if success {
                        $reviews.path = "spots/\(spot.id ?? "")/reviews"
                        showReviewViewSheet.toggle()
                    } else {
                        print("ERROR: Error saving spot!")
                    }
                }
            }
                
            
        } message: {
           Text("Möchtest Du erst speichern damit du eine Bewertung abgeben kannst?")
        }

    }
    
}
        struct SpotDetailView_Previews: PreviewProvider {
            static var previews: some View {
                NavigationStack {
                    SpotDetailView(spot: Spot(), previewRunning: true)
                        .environmentObject(SpotViewModel())
                        .environmentObject(LocationManager())
                }
            }
        }
    

