//
//  HomeViewController.swift
//  here & there
//
//  Created by Milind Sharma on 29/09/21.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import MapKit

class HomeViewController: BaseViewController, UITableViewDelegate {
    
    var viewModel: HomeViewModel!
    
    @IBOutlet weak var tblListing: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.tblListing.register(UINib(nibName: String(describing: HomeListingTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: HomeListingTableViewCell.self))
    }
    
    func setupBindings() {
        
        self.tblListing.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.viewModel.arrOptions.asObservable().bind(to: tblListing.rx.items) { tableView, index, element in
            if let cell = self.tblListing.dequeueReusableCell(withIdentifier: String(describing: HomeListingTableViewCell.self)) as? HomeListingTableViewCell {

                cell.lblName.text = element.title
                cell.imgIcon.image = element.icon
                return cell
            }
            return UITableViewCell()
        }.disposed(by: disposeBag)
        
        tblListing.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else {
                return
            }
            self.tblListing.deselectRow(at: indexPath, animated: true)
            self.viewModel.goToListing.onNext(self.viewModel.arrOptions.value[indexPath.row])
        }).disposed(by: disposeBag)
    }
    
}

extension HomeViewController {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
