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
    
    var places:[[place]] = []
    //span
    var avgCoord:CLLocationCoordinate2D?
    var spanLat:CLLocationDegrees?
    var spanLong:CLLocationDegrees?
    var maxSpan:CLLocationDegrees?
    
    var myArray = [String]()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
 
    }
    override func viewWillAppear(_ animated: Bool) {
        myArray = []
        loadMyFolders(tableView)
    }
    
    //MARK: - Handlers
    
    func hardCodePins() {
        
        var folder0:[place] = []
        places.append(folder0)
        
        //        lat: 38.6476, long: -90.3108
        let place0 = place(locationName: "place0", lat: 38.7476, long: -90.3108, city: "City0", state: "MO", folderID: 0)
        places[place0.folderID].append(place0)
        //        lat: 38.6277, long: -90.3127
        let place1 = place(locationName: "place1", lat: 38.6277, long: -90.3147, city: "City1", state: "MO", folderID: 0)
        places[place1.folderID].append(place1)
        //        lat: 38.6557, long: -90.2022
        let place2 = place(locationName: "place2", lat: 38.6557, long: -90.2022, city: "City1", state: "MO", folderID: 0)
        places[place2.folderID].append(place2)
        
        defineSpan(folder: places[0])
        
    }
    
    func defineSpan(folder:[place]) {
        var lats = [Double]()
        var longs = [Double]()
        var difsLats = [Double]()
        var difsLongs = [Double]()
        
        for place in folder {
            lats.append(place.lat)
            longs.append(place.long)
        }
        
        let sumLats = lats.reduce(0,+)
        let avgLats = sumLats/Double(lats.count)
        
        let sumLongs = longs.reduce(0,+)
        let avgLongs = sumLongs/Double(longs.count)
        
        avgCoord = CLLocationCoordinate2D(latitude: CLLocationDegrees(avgLats), longitude: CLLocationDegrees(avgLongs))
        print("\(avgLats) and \(avgLongs)")
        
        for lat in lats {
            difsLats.append(abs(avgLats-lat))
            print(abs(avgLats-lat))
        }
        for long in longs {
            difsLongs.append(abs(avgLongs-long))
            print(abs(avgLongs-long))
        }
        
        spanLat = difsLats.max()
        print(spanLat)
        spanLong = difsLongs.max()
        print(spanLong)
        
        if spanLat! > spanLong! {
            maxSpan = spanLat
        }
        else {
            maxSpan = spanLong
        }
        
    }
    
    func loadMyFolders(_ folderView: UITableView){
        folderView.reloadData()
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        
        if !(folderDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
                let myID = UserDefaults.standard.integer(forKey: "id")
                let results = try folderDB.executeQuery("select * from folders where owner=?", values:[myID])
                
                while(results.next()) {
                    let someName = results.string(forColumn: "name")
                    myArray.append(someName!)
                    
                    folderView.reloadData()
                }
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
    }
    
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
        
        self.tableView.reloadData()
    }
    

    
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! SideMenuOptionCell
//        let menuOption = MenuOption(rawValue: indexPath.row)
//        cell.folderLabel.text = menuOption?.description
        cell.textLabel!.text = myArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let menuOption = MenuOption(rawValue: indexPath.row)
        /*TODO: pass array of MKPointAnnotation, need to update delegate definition in MapViewController*/ delegate?.handleMenuToggle(forPlaceArray: places[0]) //passes menuOption to be used in animatePanel
        
    } 
}
