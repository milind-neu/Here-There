//
//  MainCoordinator.swift
//  here & there
//
//  Created by Milind Sharma on 30/09/21.
//

import Foundation
import RxSwift

class MainCoordinator: Coordinator<Void> {
    typealias Dependencies = HasWindow
    
    private let rootNavigationController: UINavigationController
    private let dependencies: Dependencies

    private let homeNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }()

    init(navigationController: UINavigationController, dependencies: Dependencies) {
        self.rootNavigationController = navigationController
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<CoordinationResult> {
        
        let viewModel = HomeViewModel(dependencies: self.dependencies)
        
        let viewController = UIStoryboard.main.homeViewController
        viewController.viewModel = viewModel
                
        viewModel.goToListing.asObserver().subscribe(onNext: { [weak self] selectedOption in
            guard let `self` = self else {
                return
            }
            self.moveToListingScreen(selectedOption: selectedOption)
        }).disposed(by: disposeBag)
        
        rootNavigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }
    
    private func moveToListingScreen(selectedOption: HomeListingOptions) {
        let viewModel = ListingViewModel(dependencies: self.dependencies)

        let viewController = UIStoryboard.main.listingViewController
        viewController.viewModel = viewModel
                        
        viewModel.goToDetail.asObserver().subscribe(onNext: { [weak self] selectedLocation in
            guard let `self` = self else {
                return
            }
            self.moveToDetailScreen(selectedLocation: selectedLocation)
        }).disposed(by: disposeBag)
        
        viewModel.selectedCategory.accept(selectedOption)
        
        rootNavigationController.pushViewController(viewController, animated: true)

    }
    
    private func moveToDetailScreen(selectedLocation: Location) {
        let viewModel = DetailViewModel(dependencies: self.dependencies, selectedLocation: selectedLocation)

        let viewController = UIStoryboard.main.detailViewController
        viewController.viewModel = viewModel
                        
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}
