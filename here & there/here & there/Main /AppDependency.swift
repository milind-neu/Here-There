//
//  AppDependency.swift
//  here & there
//
//  Created by Milind Sharma on 30/09/21.
//

import Foundation
import UIKit

protocol HasWindow {
    
    var window: UIWindow { get }
}

class AppDependency: HasWindow {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
}
