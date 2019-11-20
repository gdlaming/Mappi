//
//  EditableFolderView.swift
//  Mappi
//
//  Created by Gillian Dibbs Laming on 11/4/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class EditableFolderView: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var placesTable: UITableView!
    @IBOutlet weak var nameOfFolderLabel: UILabel!
    var folderName = "foldername"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = placesTable.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! FolderTableViewCell
        print("entered method")
        //        let myCell = friendView.dequeueReusableCell(withIdentifier: "theCell")! as! FriendTableViewCell
        print("setting text")
//        myCell.textLabel!.text = myArray[indexPath.row]
        print("set text")
        //myCell.textLabel!.text = "\(indexPath.section) Row:\(indexPath.row)"
        return myCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    
    func updateValues(){
        nameOfFolderLabel.text = folderName
    }
    
    @IBOutlet weak var folderView: UITableView!
     var myArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  


        folderView.dataSource = self
        folderView.delegate = self
        folderView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        updateValues()
        self.folderView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return myArray.count
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
//        myCell.textLabel!.text = myArray[indexPath.row]
//        return myCell
//    }
    override func viewWillAppear(_ animated: Bool) {
        myArray = []
//        loadDatabase()
        //  loadDatabase(sharedFolders)
    }
    
    func loadDatabase(){
        
        
        folderView.reloadData()
        
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        
        if !(folderDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
                let results = try folderDB.executeQuery("select * from folders", values:nil)
                
                while(results.next()) {
                    
                    
                    // need to have some conditional
                    let someName = results.string(forColumn: "name")
                    print("location name is \(String(describing: someName));")
                    myArray.append(someName!)
                    folderView.reloadData()
                    
                }
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print(myArray[indexPath.row])
            
            let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
            let folderDB = FMDatabase(path: thepath)
            
            if !(folderDB.open()) {
                print("Unable to open database")
                return
            } else {
                do{
                    let query = "delete from folders where name=?"
                    try folderDB.executeUpdate(query, values: [myArray[indexPath.row]])
                    myArray.remove(at: indexPath.row)
                    let ac = UIAlertController(title: "Item deleted", message: "" , preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
                    present(ac, animated:true, completion:nil)
                    
                    
                } catch let error as NSError {
                    print("error!")
                    print("failed \(error)")
                }
            }
            
            tableView.reloadData()
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
