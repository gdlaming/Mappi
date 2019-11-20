//
//  MenuController.swift
//  Mappi
//
//  Created by Caleb Diaz on 11/19/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit
import MapKit

private let reuseIdentifier = "SideMenuOptionCell"

class MenuController: UIViewController, MKMapViewDelegate{
    //MARK: - Properties
    
    var tableView: UITableView!
    var delegate: MapControllerDelegate?
    
        //hardcoding folder
    var places:[[MKPointAnnotation]] = []
    var folder1:[MKPointAnnotation] = []
    var currentFolder:[MKPointAnnotation] = []
    var currentSearchedPin:MKPointAnnotation?
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        hardCodePins()
    }
    
    //MARK: - Handlers
    
    func configureTableView(){
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SideMenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 40
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
        //hardcoding folder
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
        
    }
    
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! SideMenuOptionCell
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.folderLabel.text = menuOption?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption(rawValue: indexPath.row)
        delegate?.handleMenuToggle(forMenuOption: menuOption)
    } 
}
