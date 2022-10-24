//
//  DetailViewModel.swift
//  here & there
//
//  Created by Milind Sharma on 21/12/21.
//

import Foundation
import RxRelay
import RxSwift
import MapKit

class DetailViewModel: BaseViewModel {
    
    typealias Dependencies = HasWindow
    
    let dependencies: Dependencies
    
    var goToDetail = PublishSubject<Void>()
    var selectedLocation: BehaviorRelay<Location> = BehaviorRelay<Location>(value: Location.init(mapItem: MKMapItem(), distance: 0.0))
    
    init(dependencies: Dependencies, selectedLocation: Location) {
        self.dependencies = dependencies
        self.selectedLocation.accept(selectedLocation)
        super.init()
    }
    
    
}
