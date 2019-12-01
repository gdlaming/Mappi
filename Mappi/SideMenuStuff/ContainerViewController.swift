//
//  ContainerViewController.swift
//  Mappi
//
//  Created by Caleb Diaz on 11/19/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit
import MapKit

class ContainerViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Properties
    
    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    var currentArr: [MKPointAnnotation] = []
    let empty: [MKPointAnnotation] = []
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    
    //MARK: - Handlers
    
    
    func configureMapController(ann: place?){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let mapController = storyboard.instantiateViewController(withIdentifier: "Map")
            as? MapViewController {
            // Add the view controller to the container.
            mapController.delegate = self
            centerController = UINavigationController(rootViewController: mapController)
            addChild(centerController)
            view.addSubview(centerController.view)
            centerController.didMove(toParent: self)
            
            if ann != nil {
                for place in ann[0] {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(place.lat), longitude: CLLocationDegrees(place.long))
                    annotation.title = place.locationName
                    annotation.subtitle = "\(place.city) \(place.state)"
                    mapView.addAnnotation(annotation)
            }
            
//            if add {
//
//                let annotation0 = MKPointAnnotation()
//                annotation0.coordinate = CLLocationCoordinate2D(latitude: 37.77083025, longitude: -122.419498322)
//                annotation0.title = "ann0"
//
//                let annotation1 = MKPointAnnotation()
//                annotation1.coordinate = CLLocationCoordinate2D(latitude: 37.7922,longitude: -122.432)
//                annotation1.title = "ann1"
//
//                let annotation2 = MKPointAnnotation()
//                annotation2.coordinate = CLLocationCoordinate2D(latitude: 37.761,longitude: -122.422)
//                annotation2.title = "ann2"
//
////                mapController.mapView.addAnnotation(annotation0)
////                mapController.mapView.addAnnotation(annotation1)
////                mapController.mapView.addAnnotation(annotation2)
//            }
        }
    }
    
    func configureMenuController(){
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func animatePanel(shouldExpand: Bool, pins: [MKPointAnnotation]/*, menuOption: MenuOption?*/){
        if shouldExpand{
             //show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
        }
        else {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
//                guard let menuOption = menuOption else { return }
//                self.didSelectMenuOption(menuOption: menuOption)
                self.didSelectMenuOption()
            }
        }
        
        animateStatusBar()
    }
    
//    func didSelectMenuOption(menuOption: MenuOption) {
//        switch menuOption{
//
//        case .Option1:
//            configureMapController()
//        case .Option2:
//            print("hi")
//        case .Option3:
//            print("hi")
//        }
//    }
    
    //TODO: update to receive array MKPointAnnotation
    func didSelectMenuOption(ann: [MKPointAnnotation]) {
        return
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

//TODO: update to receive array of MKPointAnnotation
extension ContainerViewController: MapControllerDelegate{
    func handleMenuToggle(forMKArray annArr: [MKPointAnnotation]?) {
        if !isExpanded{
            configureMenuController()
        }
        
        
        currentArr = annArr ?? empty

        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, pins: currentArr)
    }
    
    
}
