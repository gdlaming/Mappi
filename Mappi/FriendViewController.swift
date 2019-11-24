//
//  FriendViewController.swift
//  Mappi
//
//  Created by Cole Makuch on 11/17/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return folderArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return folderArray[row]
    }
 
    var labelName = ""
    var folderArray = [String]()
    var folderIDs = [Int]()
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mapPicker: UIPickerView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareButton(_ sender: Any) {
        let thisFolderIndex = mapPicker.selectedRow(inComponent: 0)
        let thisFolderID = folderIDs[thisFolderIndex]
        print("thisFolderID = \(thisFolderID)")
        shareFolder(labelName, thisFolderID)
        
        let alert = UIAlertController(title: "Shared folder with \(labelName)", message: "Hope they're ready to explore!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findFolders()
        self.mapPicker.delegate = self
        self.mapPicker.dataSource = self

        nameLabel.text = labelName

        self.mapPicker.reloadAllComponents()
    }

    // pull my folders from db
    func findFolders(){

        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        if !(folderDB.open()) {
            print("Unable to open database")
        } else {
            do{
                let query = "select * from folders where owner=?"
                let myID = UserDefaults.standard.integer(forKey: "id")
                let f = try folderDB.executeQuery(query, values: [myID])
                while(f.next()){
                    let folder = f.string(forColumn: "name")!
                    let folderID = f.string(forColumn: "folderID")
                    folderIDs.append(Int(folderID!)!)
                    folderArray.append(folder)
                }
            } catch let error as NSError {
                print("failed \(error)")
            }
        }
    }
    
    // get userID of friend we share with
    // insert folderID = ?, sharedUserID = ? to sharedFolders
    func shareFolder(_ labelName : String, _ folderID : Int){
        let first = labelName.split(separator: " ")[0]
        let last = labelName.split(separator: " ")[1]
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        if !(folderDB.open()) {
            print("Unable to open database")
        } else {
            do{
                let f = try folderDB.executeQuery("select * from users where firstName=? and lastName=?", values: [first, last])
                var sharedUserID = 0
                while(f.next()){
                    sharedUserID = Int(f.int(forColumn: "userID"))
                }
                try folderDB.executeUpdate("INSERT INTO sharedFolders (folderID, sharedUserID) VALUES (?, ?)", values:[folderID, sharedUserID])
            } catch let error as NSError {
                print("failed \(error)")
            }
        }
    }
}
