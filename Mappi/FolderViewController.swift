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
    var myArray1Colors = [UIColor]()
    var myArray2 = [String]()
    var myArray2Colors = [UIColor]()

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
            myCell.backgroundColor = myArray1Colors[indexPath.row]
            return myCell
        }
        else { //sharedFolders tableview
            let myCell = tableView.dequeueReusableCell(withIdentifier: "sharedCell")! 
            myCell.textLabel!.text = myArray2[indexPath.row]
            myCell.backgroundColor = myArray2Colors[indexPath.row]
            return myCell
        }
    }
    var selectedFolderName = ""
    var selectedFolderColor = UIColor()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.myFolders{
            selectedFolderName = myArray1[indexPath.item]
            selectedFolderColor = myArray1Colors[indexPath.item]
            performSegue(withIdentifier: "mySegue", sender: self)
        }
        else{
            selectedFolderName = myArray2[indexPath.item]
            selectedFolderColor = myArray2Colors[indexPath.item]
            performSegue(withIdentifier: "sharedSegue", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sharedSegue")
        {
            print("entering shared segue")
            let sharedFolderVC = segue.destination as? SharedFolderViewController
            sharedFolderVC?.folderName = selectedFolderName
            sharedFolderVC?.folderColor = selectedFolderColor
        }
        if (segue.identifier == "mySegue")
        {
            print("entering my segue")
            let myFolderVC = segue.destination as? EditableFolderView
            myFolderVC?.folderName = selectedFolderName
            myFolderVC?.folderColor = selectedFolderColor
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        myArray1 = []
        myArray1Colors = []
        loadMyFolders(myFolders)
        myArray2 = []
        myArray2Colors = []
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
                    myArray1.append(someName!)
                    let colorString = results.string(forColumn: "color")!
                   
                    myArray1Colors.append(getColor(colorString: colorString))
                    folderView.reloadData()
                }
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
    }
    
    func getColor(colorString : String) -> UIColor {
        if (colorString == "blue"){
            return UIColor(red: 79/255, green: 219/255, blue: 224/255, alpha: 0.3)
        }
        if (colorString == "red"){
            return UIColor(red: 252/255, green: 61/255, blue: 70/255, alpha: 0.3)
        }
        if (colorString == "green"){
            return UIColor(red: 190/255, green: 223/255, blue: 83/255, alpha: 0.3)
        }
        if (colorString == "purple"){
            return UIColor(red: 189/255, green: 78/255, blue: 223/255, alpha: 0.3)
        }
        else {
            return UIColor.white
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
                        let colorString = results2.string(forColumn: "color")!
                        
                        myArray2Colors.append(getColor(colorString: colorString))
                    }
                    
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
