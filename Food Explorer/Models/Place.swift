//
//  Place.swift
//  PLaceLookupDemo
//
//  Created by Dennis Sand on 21.11.22.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name : String {
        self.mapItem.name ?? ""
    }
    
    var address: String {
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        var address = ""
        
        cityAndState = placemark.locality ?? "" //city
        if let state = placemark.administrativeArea {
            // Show either state or city, state
            cityAndState = cityAndState.isEmpty ? state: "\(cityAndState), \(state)"
        }
        
        address = placemark.subThoroughfare ?? ""
        if let street = placemark.thoroughfare {
            address = address.isEmpty ? street: "\(address) \(street)"
        }
        
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            address = cityAndState
        } else {
            address = cityAndState.isEmpty ? address : "\(address), \(cityAndState)"
        }
        
        return address
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }

    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }
}
