//
//  DetailViewController.swift
//  here & there
//
//  Created by Milind Sharma on 21/12/21.
//

import UIKit
import MapKit

final class DetailViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnOpenInMaps: HTButton!
    @IBOutlet weak var btnAddToFavourites: HTButton!
    @IBOutlet weak var btnShare: HTButton!
    @IBOutlet weak var btnCall: HTButton!
    @IBOutlet weak var btnWebsite: HTButton!
    @IBOutlet weak var lblAddress: UILabel!

    // MARK: - Variables
    var viewModel: DetailViewModel!
    var regionHasBeenCentered = false
    let locationManager = CLLocationManager()
    private var currentPlace: CLPlacemark?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addRoute()
        setupBinding()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        guard let mapItem = self.viewModel.selectedLocation.value.mapItem else {
            return
        }
        
        self.setNavigationAttributes(title: mapItem.name?.capitalized ?? "")
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.isZoomEnabled = true
        mapView.mapType = .standard
        
        let address = (mapItem.placemark.name ?? "") + ", " + (mapItem.placemark.title ?? "")
        self.lblAddress.text = address
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.viewModel.selectedLocation.value.mapItem.placemark.coordinate.latitude, longitude: self.viewModel.selectedLocation.value.mapItem.placemark.coordinate.longitude)
        
        annotation.title = self.viewModel.selectedLocation.value.mapItem.name
        mapView.addAnnotation(annotation)

        
    }
    
    func setupBinding() {
        
        btnOpenInMaps.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.openMaps()
        }).disposed(by: disposeBag)
        
        btnShare.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.shareLocation()
        }).disposed(by: disposeBag)
        
        btnWebsite.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.openWebsite()
        }).disposed(by: disposeBag)
        
        btnCall.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.callNumber()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods
    // Function to get url with source and destination coordinates
    func getURL() -> String {
        guard let sourceLocationCoordinate = locationManager.location?.coordinate else {
            return ""
        }
        
        let destLocationCoordinate = self.viewModel.selectedLocation.value.mapItem.placemark.coordinate
        
        return "http://maps.apple.com/?saddr=\(sourceLocationCoordinate.latitude),\(sourceLocationCoordinate.longitude)&daddr=\(destLocationCoordinate.latitude),\(destLocationCoordinate.longitude)"

    }
    
    // Function to add route in the map view
    func addRoute() {
        let request = MKDirections.Request()

        request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D()))
        request.destination = self.viewModel.selectedLocation.value.mapItem

        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            guard let response = response else { return }
            let routes = response.routes
            
            if let fastestRoute = routes.sorted(by: {($0.distance < $1.distance)}).first {
                self.mapView.addOverlay(fastestRoute.polyline)
                self.mapView.setVisibleMapRect(fastestRoute.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func callNumber() {
        let phoneNumber = self.viewModel.selectedLocation.value.mapItem.phoneNumber
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // Function to open maps app with source and destination
    func openMaps() {
        let directionsURL = getURL()
        
        guard let url = URL(string: directionsURL) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // Function to open website with location url
    func openWebsite() {
        let website = self.viewModel.selectedLocation.value.mapItem.url
        
        guard let url = website else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // Function to share the location details with someone
    func shareLocation() {
        // Setting description
        let name = self.viewModel.selectedLocation.value.mapItem.name ?? ""
        
        let directionsURL = getURL()

        let url : NSURL = NSURL(string: directionsURL)!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [name, url], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (btnShare)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

// MARK: - LocationManagerDelegate and MKMapViewDelegate
extension DetailViewController: CLLocationManagerDelegate, MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .green
        renderer.lineWidth = 5
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]

            if !regionHasBeenCentered {
                let span: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 40.0, longitudeDelta: 40.0)
                let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                let region: MKCoordinateRegion = MKCoordinateRegion.init(center: userLocation, span: span)

//                mapView.setRegion(region, animated: true)
                
                //Zoom to user location
//                    if let userLocation = locationManager.location?.coordinate {
                        let viewRegion = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
                        mapView.setRegion(viewRegion, animated: true)
//                    }
                
                regionHasBeenCentered = true
            }

            self.mapView.showsUserLocation = true
        
        
        CLGeocoder().reverseGeocodeLocation(location) { places, _ in
            guard
              let firstPlace = places?.first
              else {
                return
            }
            
            self.currentPlace = firstPlace
          }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        if mapView.region.span.latitudeDelta <= 40 && mapView.region.span.longitudeDelta <= 40 {
//                 let minimumSpan = MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
//                 let minimumRegion = MKCoordinateRegion(center: mapView.centerCoordinate, span: minimumSpan)
//                 mapView.setRegion(minimumRegion, animated: false)
//            }
    }
}
