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
    var currentID: Int = 0
    
    var delegate: MenuControllerDelegate?

    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapController(ID: currentID)
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
    
    @objc func passID(){
        delegate?.passID(forID: nil)
    }
    
    func configureMapController(ID: Int?){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let mapController = storyboard.instantiateViewController(withIdentifier: "Map")
            as? MapViewController {
            // Add the view controller to the container.
            mapController.delegate = self
            mapController.currentID = ID ?? currentID
            centerController = UINavigationController(rootViewController: mapController)
            addChild(centerController)
            view.addSubview(centerController.view)
            centerController.didMove(toParent: self)
            
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
    
    func animatePanel(shouldExpand: Bool, ID: Int){
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
                self.didSelectMenuOption(ID: ID)
            }
        }
        
        animateStatusBar()
    }

    func didSelectMenuOption(ID: Int) {
//        print("in didselect")
//            delegate?.passID(forID: ID)
        print(ID)
        currentID = ID
        let defaults = UserDefaults.standard
        var folderID = defaults.integer(forKey: "id")
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}


extension ContainerViewController: MapControllerDelegate{
    func handleMenuToggle(forID id: Int?) {
        if !isExpanded{

            configureMenuController()
            delegate?.passID(forID: id)
        }
        

        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, ID: id ?? currentID)
    }
    
}

