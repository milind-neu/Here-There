//
//  HomeModel.swift
//  here & there
//
//  Created by Milind Sharma on 29/09/21.
//

import Foundation
import UIKit

enum HomeListingOptions {
    case hotels
    case cafes
    case movieTheatres
    case banks
    case bars
    case pubs
    case gasStations
    case hospitals
    case pharmacies
    case restaurants
    case supermarkets
    
    var title: String {
        switch self {
        case .hotels:
            return "Hotels"
        case .cafes:
            return "Cafes"
        case .movieTheatres:
            return "Movie theatres"
        case .banks:
            return "Banks"
        case .bars:
            return "Bars"
        case .pubs:
            return "Pubs"
        case .gasStations:
            return "Gas stations"
        case .hospitals:
            return "Hospitals"
        case .pharmacies:
            return "Pharmacies"
        case .restaurants:
            return "Restaurants"
        case .supermarkets:
            return "Supermarkets"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .hotels:
            return UIImage(named: "hotelIcon")
        case .cafes:
            return UIImage(named: "cafeIcon")
        case .movieTheatres:
            return UIImage(named: "movieTheatreIcon")
        case .banks:
            return UIImage(named: "bankIcon")
        case .bars:
            return UIImage(named: "barIcon")
        case .pubs:
            return UIImage(named: "pubIcon")
        case .gasStations:
            return UIImage(named: "gasStationIcon")
        case .hospitals:
            return UIImage(named: "hospitalIcon")
        case .pharmacies:
            return UIImage(named: "pharmacyIcon")
        case .restaurants:
            return UIImage(named: "restaurantIcon")
        case .supermarkets:
            return UIImage(named: "supermarketIcon")
        }

    }
}
