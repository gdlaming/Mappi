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
        return myArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myArray[row]
    }
    

    
    var myArray = [String]()
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mapPicker: UIPickerView!
    @IBOutlet weak var shareButton: UIButton!
    
    
    var labelName = ""
    
    func updateValues(){
        nameLabel.text = labelName
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateValues()
        self.mapPicker.delegate = self
        self.mapPicker.dataSource = self
        loadDatabase()
        self.mapPicker.reloadAllComponents()
//        findFolders(<#T##folderArray: [Int]##[Int]#>)
        // Do any additional setup after loading the view.
    }
    func loadDatabase(){
        var friendArray = [Int]()
        
        mapPicker.reloadAllComponents()
        
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        
        if !(folderDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
                let results = try folderDB.executeQuery("select * from friends", values:nil)
                
                while(results.next()) {
                    
                    let curUserID = results.string(forColumn: "userID")
                    let id = UserDefaults.standard.string(forKey: "id")!
                    if (curUserID == id){
                        let friendID = results.int(forColumn: "friendID")
                        friendArray.append(Int(friendID))
                    }
                    
                }
                findFolders(friendArray)
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
            
            mapPicker.reloadAllComponents()
            //TODO: need to grab all the friendships of the current user
            //(stored in user defaults)
            //then, need to look up display name based on userID from the
            //user table. Add those names to the array to be displayed.
        }
    }

    func findFolders(_ folderArray: [Int]){
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        if !(folderDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
//                for friendID in folderArray{
                for folderID in folderArray{
                    let query = "select * from users where userID=?"
                    let f = try folderDB.executeQuery(query, values: [folderID])
                    while(f.next()){
                        let folder = f.string(forColumn: "name")
//                print (String(folder!))
                        //print("friend name: \(first!) \(last!)")
//                        let name: String = first! + " " + last!
                        myArray.append("test1")
                        myArray.append("test 2")
//                        myArray.append(String(folder!))
                    }
                    
                }
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
