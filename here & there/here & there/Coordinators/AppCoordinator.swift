//
//  AppCoordinator.swift
//  here & there
//
//  Created by Milind Sharma on 30/09/21.
//

import Foundation
import RxSwift

final class AppCoordinator: Coordinator<Void> {
    
    private let navigationController: UINavigationController
    private let window: UIWindow
    let dependencies: AppDependency
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
        self.dependencies = AppDependency(window: self.window)
    }
    
    override func start() -> Observable<Void> {
        return showSplash()
    }
    
    private func showSplash() -> Observable<Void> {
        let mainCoordinator = MainCoordinator(navigationController: navigationController, dependencies: self.dependencies)
        return coordinate(to: mainCoordinator)
    }

}
