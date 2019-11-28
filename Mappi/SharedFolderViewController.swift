//
//  SharedFolderViewController.swift
//  Mappi
//
//  Created by Cole Makuch on 11/17/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit
//testing 1-2-3
class SharedFolderViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var placesTable: UITableView!
    
    @IBOutlet weak var folderView: UITableView!
    var places = [[String?]]()
    var folderName = ""
    var folderColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IDLabel.text = folderName
        IDLabel.textColor = folderColor.withAlphaComponent(1.0)
        places = getPlaces()
        folderView.dataSource = self
        folderView.delegate = self
        folderView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
       
        self.folderView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = placesTable.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! FriendTableViewCell
       
        myCell.placeTitleLabel.text = places[indexPath.item][0]!
        myCell.placeDescriptionText.text = places[indexPath.item][1]!
        myCell.button.tintColor = folderColor.withAlphaComponent(1.0)
        myCell.button.setTitle(places[indexPath.item][0]!, for: .normal)
        myCell.button.setTitleColor(UIColor(white: 0, alpha: 0), for: .normal)
        
        let visited = UserDefaults.standard.stringArray(forKey: "visited") ?? [String?]()
        if (visited.contains(places[indexPath.item][0]!)){
            myCell.button.setImage(UIImage(named: "check.png"), for: .normal)
        } else {
            myCell.button.setImage(UIImage(named: "uncheck.png"), for: .normal)
        }
        
        return myCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    @IBAction func checkClicked(_ sender: Any) {
        // list of visited places
        var visited = UserDefaults.standard.stringArray(forKey: "visited") ?? [String?]()
        let thisButton = sender as! UIButton
        let placeName = thisButton.currentTitle
        
        if (visited.contains(placeName)){  // uncheck
            thisButton.setImage(UIImage(named: "uncheck.png"), for: .normal)
            visited.removeAll { $0 == placeName }
            UserDefaults.standard.set(visited, forKey: "visited")
        } else {
            thisButton.setImage(UIImage(named: "check.png"), for: .normal)
            visited.append(placeName)
            UserDefaults.standard.set(visited, forKey: "visited")
        }
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
