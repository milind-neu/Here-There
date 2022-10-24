//
//  AppDelegate.swift
//  here & there
//
//  Created by Milind Sharma on 28/09/21.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let disposeBag = DisposeBag()

    private let navController: UINavigationController = {
        let navController = UINavigationController()
        navController.navigationBar.isTranslucent = true
        return navController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        guard let mainWindow = window else {
            return true
        }
        window?.makeKeyAndVisible()

        appCoordinator = AppCoordinator(window: mainWindow, navigationController: navController)
        appCoordinator?.start().subscribe().disposed(by: disposeBag)

        return true
    }

}

