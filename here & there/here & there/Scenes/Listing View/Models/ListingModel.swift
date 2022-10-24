//
//  ListingModel.swift
//  here & there
//
//  Created by Milind Sharma on 30/09/21.
//

import Foundation
import MapKit

struct Location {
    var mapItem: MKMapItem!
    var distance: Double!
    
    init(mapItem: MKMapItem, distance: Double) {
        self.mapItem = mapItem
        self.distance = distance
    }

}
