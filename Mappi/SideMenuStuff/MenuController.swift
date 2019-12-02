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
    var delegate2: MenuControllerDelegate?
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
    


    
    func getFolderID(folderName : String) -> Int{
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        
        if !(folderDB.open()) {
            print("Unable to open database")
        } else {
            do{
                let results = try folderDB.executeQuery("select * from folders where name=?", values:[folderName])
                
                while(results.next()) {
                    let folderID = Int(results.int(forColumn: "folderID"))
                    folderDB.close()
                    return folderID
                }
            }
            catch let error as NSError {
                print("failed \(error)")
            }
        }
        return 0
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

        let folderID = getFolderID(folderName : myArray[indexPath.row])
        if (folderID != 12489128931){
            delegate2?.passID(forID: folderID)
            delegate?.handleMenuToggle(forID: folderID)
        } else {
            print("failed to get folderID")
        }

        
    } 
}
