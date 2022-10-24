//
//  BaseViewModel.swift
//  here & there
//
//  Created by Milind Sharma on 29/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    let alertDialog = PublishSubject<(String)>()
    let toastMessage = PublishSubject<(String)>()
}
