//
//  ListingViewController.swift
//  here & there
//
//  Created by Milind Sharma on 30/09/21.
//

import UIKit
import MapKit

class ListingViewController: BaseViewController, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tblListing: UITableView!
    
    var viewModel: ListingViewModel!

    var searchController: UISearchController!
    var annotation: MKAnnotation!
    var localSearchRequest: MKLocalSearch.Request!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearch.Response!
    var error: NSError!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    let locationManager = CLLocationManager()
    var locationValue: CLLocationCoordinate2D?
    
    var distanceInMiles = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupBinding()
        search()
    }
    
    func setupUI() {
        self.setNavigationAttributes(title: self.viewModel.selectedCategory.value.title)

        self.tblListing.register(UINib(nibName: String(describing: ListingTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: ListingTableViewCell.self))
        
        DispatchQueue.global(qos: .background).async {
            if CLLocationManager.locationServicesEnabled() {
                // Ask for Authorisation from the User.
                self.locationManager.requestAlwaysAuthorization()

                // For use in foreground
                self.locationManager.requestWhenInUseAuthorization()


                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
            
        }
    }
    
    func setupBinding() {
        self.tblListing.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.viewModel.arrAvailablePlaces.asObservable().bind(to: tblListing.rx.items) { tableView, index, element in
            if let cell = self.tblListing.dequeueReusableCell(withIdentifier: String(describing: ListingTableViewCell.self)) as? ListingTableViewCell {

                cell.configure(item: element)
                return cell
            }
            return UITableViewCell()
        }.disposed(by: disposeBag)
        
        tblListing.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else {
                return
            }
            self.viewModel.goToDetail.onNext(self.viewModel.arrAvailablePlaces.value[indexPath.row])
            self.tblListing.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)

    }
    
    func search() {
        
        guard let coordinate = locationManager.location?.coordinate, let lat = locationValue?.latitude, let long = locationValue?.longitude else {
            return
        }
        
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = self.viewModel.selectedCategory.value.title
        localSearchRequest.region = .init(center: coordinate, latitudinalMeters: lat, longitudinalMeters: long)
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            var distanceInMeters = 0.0
            let currentLocation: CLLocation =  CLLocation(latitude: self.locationValue?.latitude ?? 0.0, longitude: self.locationValue?.longitude ?? 0.0)

            self.viewModel.arrAvailablePlaces.accept([])

            if let items = localSearchResponse?.mapItems {
                for item in items {
                    
                    if let loc = item.placemark.location {
                        distanceInMeters = Double(Int(currentLocation.distance(from: loc)))
                        
                        let location = Location(mapItem: item, distance: distanceInMeters)
                        var arr = self.viewModel.arrAvailablePlaces.value
                        arr.append(location)
                        
                        arr.sort(by: {$0.distance < $1.distance})
                        
                        self.viewModel.arrAvailablePlaces.accept(arr)


                    }

                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationValue = locValue
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        search()
        locationManager.stopUpdatingLocation()
    }

}

