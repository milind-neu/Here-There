//
//  HomeViewModel.swift
//  here & there
//
//  Created by Milind Sharma on 29/09/21.
//

import Foundation
import RxRelay
import RxSwift

class HomeViewModel: BaseViewModel {
    
    typealias Dependencies = HasWindow
    
    let dependencies: Dependencies
    let arrOptions: BehaviorRelay<[HomeListingOptions]> = BehaviorRelay(value: [.hotels, .cafes, .movieTheatres, .banks, .bars, .pubs, .gasStations, .hospitals, .pharmacies, .restaurants, .supermarkets])
    
    var goToListing = PublishSubject<HomeListingOptions>()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    
}
