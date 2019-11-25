//
//  FolderViewController.swift
//  Mappi
//
//  Created by Gillian Dibbs Laming on 11/4/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myFolders: UITableView!
    @IBOutlet weak var sharedFolders: UITableView!
    var myArray1 = [String]()
    var myArray1IDs = [Int]()
    var myArray2 = [String]()
    var myArray2IDs = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        myFolders.dataSource = self
        myFolders.delegate = self
        sharedFolders.dataSource = self
        sharedFolders.delegate = self
        self.myFolders.reloadData()
        self.sharedFolders.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == self.myFolders{
            return myArray1.count
        }
         else{
            return myArray2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.myFolders{
            let myCell = tableView.dequeueReusableCell(withIdentifier: "myFoldersCell")! 
            myCell.textLabel!.text = myArray1[indexPath.row]
            return myCell
        }
        else { //sharedFolders tableview
            let myCell = tableView.dequeueReusableCell(withIdentifier: "sharedCell")! 
            myCell.textLabel!.text = myArray2[indexPath.row]
            return myCell
        }
    }
    var selectedFolderName = ""

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.myFolders{
            selectedFolderName = myArray1[indexPath.item]
            performSegue(withIdentifier: "mySegue", sender: self)
        }
        else{
            selectedFolderName = myArray2[indexPath.item]
            performSegue(withIdentifier: "sharedSegue", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sharedSegue")
        {
            print("entering shared segue")
            let sharedFolderVC = segue.destination as? SharedFolderViewController
            sharedFolderVC?.folderName = selectedFolderName
        }
        if (segue.identifier == "mySegue")
        {
            print("entering my segue")
            let sharedFolderVC = segue.destination as? EditableFolderView
            sharedFolderVC?.folderName = selectedFolderName
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        myArray1 = []
        loadMyFolders(myFolders)
        myArray2 = []
        loadSharedFolders(sharedFolders)
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
//                    let someID = results.int(forColumn: "folderID")
                    print("location name is \(String(describing: someName));")
                   
                        myArray1.append(someName!)
//                        myArray1IDs.append(Int(someID))
                    folderView.reloadData()
                }
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
    }
    
    func loadSharedFolders(_ folderView: UITableView){
        folderView.reloadData()
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        
        if !(folderDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
                let myID = UserDefaults.standard.integer(forKey: "id")
                let results = try folderDB.executeQuery("select * from sharedFolders where sharedUserID=?", values:[myID])
                
                while(results.next()) {
                    let folderID = Int(results.int(forColumn: "folderID"))
                    let results2 = try folderDB.executeQuery("select * from folders where folderID=?", values: [folderID])
                    while(results2.next()){
                        let someName = results2.string(forColumn: "name")
                        myArray2.append(someName!)
                    }
                    
                    //myArray2IDs.append(Int(folderID))
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
                //print(myArray1[indexPath.row])
                
                let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
                let folderDB = FMDatabase(path: thepath)
                
                if !(folderDB.open()) {
                    print("Unable to open database")
                    return
                } else {
                    if tableView == self.myFolders{
                      
                        myArray1 = executeUpdates(&myArray1, indexPath)
                    }
                    else{
                        myArray2 = executeUpdates(&myArray2, indexPath)
                    }
                }
                tableView.reloadData()
            }
        }
    }

func executeUpdates(_ array: inout [String], _ indexPath: IndexPath) -> [String]{
    let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
    let folderDB = FMDatabase(path: thepath)
    if !(folderDB.open()) {
        print("Unable to open database")
        return array
    }
    else {
        do{
        let query = "delete from folders where name=?"
        try folderDB.executeUpdate(query, values: [array[indexPath.row]])
        array.remove(at: indexPath.row)
        let ac = UIAlertController(title: "Invalid Credentials", message: "Please check your username and password" , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
       // present(ac, animated:true, completion:nil)
        //need to fix
        return array
    }
    catch let error as NSError {
        print("error!")
        print("failed \(error)")
    }
    return array
}

}
