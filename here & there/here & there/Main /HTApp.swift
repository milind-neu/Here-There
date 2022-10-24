//
//  HTApp.swift
//  here & there
//
//  Created by Milind Sharma on 28/09/21.
//

import Foundation
import IQKeyboardManagerSwift

final class HTApp {

    var bundleName: String {
        return (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ("Base Structure")
    }
    
    static let shared = HTApp()
    private init() {
        
    }
    
    func prepare() {
        configureIQKeyboardManager()
    }
    
    private func configureIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
}
