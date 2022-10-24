//
//  BaseViewController.swift
//  here & there
//
//  Created by Milind Sharma on 29/09/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension BaseViewController {
    
    func setNavigationAttributes(title: String, _ image: UIImage = #imageLiteral(resourceName: "backArrow"), _ leftBarBtnSelector: Selector = #selector(onClickBackButton)) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let navigationHeight = self.navigationController?.navigationBar.frame.size.height
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0))
        button.contentHorizontalAlignment = .left
        button.setImage(image, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 0
        button.setTitleColor(UIColor.black, for: .normal)

        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: leftBarBtnSelector, for: .touchUpInside)
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 44, height: navigationHeight ?? 44.0))
        leftView.addSubview(button)
        let leftBarButtonItem = UIBarButtonItem(customView: leftView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 26.0)
        ]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func onClickBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
