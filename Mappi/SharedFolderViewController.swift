//
//  SharedFolderViewController.swift
//  Mappi
//
//  Created by Cole Makuch on 11/17/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class SharedFolderViewController: UIViewController {

    @IBOutlet weak var placesTable: UITableView!
    @IBOutlet weak var IDLabel: UILabel!
    
    @IBOutlet weak var folderView: UITableView!
    
    var folderName = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
      //  folderView.dataSource = self
      //  folderView.delegate = self
        folderView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        IDLabel.text = folderName
        self.folderView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = placesTable.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! FolderTableViewCell
        
        var places = getPlaces()
        myCell.colorLabel.backgroundColor = UIColor.blue
        print(places)
        myCell.placeTitleLabel.text = places[indexPath.item][0]!
        myCell.placeDescriptionText.text = places[indexPath.item][1]!

        return myCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPlaces().count
    }
    
    func getPlaces() -> [[String?]]{
        var places = [[String?]]()
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let DB = FMDatabase(path: thepath)
        
        var folderID = 0
        if !(DB.open()) {
            print("Unable to open database")
        } else {
            do{
                let folderResults = try DB.executeQuery("select * from folders where name=?", values:[folderName])
                while(folderResults.next()){
                    folderID = Int(folderResults.int(forColumn: "folderID"))
                }
                let results = try DB.executeQuery("select * from places where folderID=?", values:[folderID])
                while(results.next()) {
                    let placeName = results.string(forColumn: "locationName")
                    let desc = results.string(forColumn: "description")
                    let city = results.string(forColumn: "city")
                    let state = results.string(forColumn: "state")
                    let arr = [placeName, desc, city, state]
                    places.append(arr)
                }
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
        return places
    }

}
