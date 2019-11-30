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

class MapViewController: UIViewController, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    
    var selectedPin:MKPlacemark? = nil
    let btnAdd = UIButton(type: .contactAdd)
    
    @IBOutlet weak var mapView: MKMapView!
    
    //hardcode array
    var places:[[MKPointAnnotation]] = []
    var folder1:[MKPointAnnotation] = []
    var currentFolder:[MKPointAnnotation] = []
    var currentSearchedPin:MKPointAnnotation?
    
    //picker
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var pickerFolder:String?
    
    override func viewDidLoad() {
        //will need to go into this and run some stuff in the background probably
        super.viewDidLoad()
        
        //        self.picker.delegate = self
        //        self.picker.dataSource = self as? UIPickerViewDataSource
        
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
        
        
        hardCodePins()
        configureNavBar()
    }
    
    var delegate: MapControllerDelegate?
    
    @objc func handleMenuToggle(){
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sidemenu"), style: .plain, target: self, action: #selector(handleMenuToggle))
        
    }
    
    //3 locations hardcoded into "folder1" - right now you should be able to search for another location and add it
    //right now view doesn't expand to include all pins so these just fit within view as it is. need to change this.
    func hardCodePins() {
        
        let annotation0 = MKPointAnnotation()
        annotation0.coordinate = CLLocationCoordinate2D(latitude: 38.6476,longitude: -90.3108)
        annotation0.title = "ann0"
        folder1.append(annotation0)
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 38.6277,longitude: -90.3127)
        annotation1.title = "ann1"
        folder1.append(annotation1)
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 38.6557,longitude: -90.3022)
        annotation2.title = "ann2"
        folder1.append(annotation2)
        
        places.append(folder1)
        currentFolder = folder1
        
        mapView.addAnnotation(folder1[0])
        mapView.addAnnotation(folder1[1])
        mapView.addAnnotation(folder1[2])
        
    }
    
    
    
    //more editing on creating the pin, all other pin content should be put in here i think
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        //adds button, clicking this should prompt some kind of way to add to existing list or start new list. right now it just adds to the existing hardcoded list. maybe put button in menu view to add new folder?
        annotationView?.rightCalloutAccessoryView = btnAdd
        btnAdd.addTarget(self, action: #selector(clickBtnAdd), for: .touchUpInside)
        
        return annotationView
    }
    
    //adds searched location to array, need to account for trying to add same location multiple times
    @objc
    func clickBtnAdd(sender: UIButton!) {
        picker = UIPickerView.init()
        self.picker.delegate = self as UIPickerViewDelegate
        self.picker.dataSource = self as UIPickerViewDataSource
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped)),UIBarButtonItem.init(title: "Add to Folder", style: .plain, target: self, action: #selector(onAddButtonTapped))]
        self.view.addSubview(toolBar)
        //        folder1.append(currentSearchedPin!)
        //        for point in folder1 {
        //            print(point.title)
        
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    @objc func onAddButtonTapped() {
        print("current pin added to \(pickerFolder)")
    }
    
    var pickerTest = ["one", "two"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTest.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTest[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerFolder = pickerTest[row]
        print(pickerFolder)
    }
    
}

//current location
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

//creates annotation based on search
//also search seems pretty limited to locations close to current map view, confirm if this is ok
extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        
        // clear existing pins, may want to remove this
        mapView.removeAnnotations(mapView.annotations)
        
        //creates annotation based on placemark info
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        print(annotation.coordinate)
        annotation.title = placemark.name
        
        //annotation.subtitle = "content if there's something else we want to show other than city state"
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        currentSearchedPin = annotation
        //adds annotation to map
        mapView.addAnnotation(annotation)
        
        let span:MKCoordinateSpan
        //zoom in on selected pin
        //need to get this to change when multiple pins on page
        span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

