//
//  ListingViewModel.swift
//  here & there
//
//  Created by Milind Sharma on 30/09/21.
//

import Foundation
import RxRelay
import RxSwift
import MapKit

class ListingViewModel: BaseViewModel {
    
    typealias Dependencies = HasWindow
    
    let dependencies: Dependencies
    
    var goToDetail = PublishSubject<Location>()
    var selectedCategory: BehaviorRelay<HomeListingOptions> = BehaviorRelay(value: .hotels)
    var arrAvailablePlaces: BehaviorRelay<[Location]> = BehaviorRelay(value: [])
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    
}
