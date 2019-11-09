//
//  MapViewController.swift
//  Mappi
//
//  Created by Gillian Dibbs Laming on 11/4/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController {

    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var menuView: UITableView!
    
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    
    var selectedPin:MKPlacemark? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        //will need to go into this and run some stuff in the background probably
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let searchResultsTable = storyboard!.instantiateViewController(withIdentifier: "SearchResultsTable") as! SearchResultsTable
        resultSearchController = UISearchController(searchResultsController: searchResultsTable)
        resultSearchController?.searchResultsUpdater = searchResultsTable 
    
        //search controller
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        searchResultsTable.mapView = mapView
        
        searchResultsTable.handleMapSearchDelegate = self
        
        //hamburger menu
        menuView.isHidden = true
        dimView.alpha = 0
        dimView.isHidden = true
        dimView.addGestureRecognizer(tapGestureRecognizer)
    }
    
//hamburger menu functions - need to make class for these functions so open and close can be called in multiple instances (touch search bar should close menu)
    @IBAction func sideButtonPressed(_ sender: Any) {
        self.dimView.isHidden = false
//        self.navigationController?.isNavigationBarHidden = true

        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.dimView.alpha = 0.9
            self.menuView.isHidden = false
            
        }, completion: { (complete) in
//            self.panGesture.isEnabled = false
        })
    }

    @IBAction func closeMenu(_ sender: Any) {
        menuView.isHidden = true
//        self.navigationController?.isNavigationBarHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.dimView.alpha = 0
            
        }, completion: { (complete) in
//            self.panGesture.isEnabled = true
            self.dimView.isHidden = true
        })
    }
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error)")
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
