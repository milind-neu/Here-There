//
//  UIStoryBoard.swift
//  here & there
//
//  Created by Milind Sharma on 30/09/21.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
}

extension UIStoryboard {
    
    var homeViewController: HomeViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as? HomeViewController else {
            fatalError(String(describing: HomeViewController.self) + " couldn't be found in Storyboard file")
        }
        return viewController
    }
    
    var listingViewController: ListingViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: ListingViewController.self)) as? ListingViewController else {
            fatalError(String(describing: ListingViewController.self) + " couldn't be found in Storyboard file")
        }
        return viewController
    }

    var detailViewController: DetailViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else {
            fatalError(String(describing: DetailViewController.self) + " couldn't be found in Storyboard file")
        }
        return viewController
    }
}
