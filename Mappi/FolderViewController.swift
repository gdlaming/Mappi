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
    var myArray2 = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
       // loadDatabase(myFolders)
        myFolders.dataSource = self
        myFolders.delegate = self
        myFolders.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        sharedFolders.dataSource = self
        sharedFolders.delegate = self
        sharedFolders.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
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
            let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
            myCell.textLabel!.text = myArray1[indexPath.row]
            return myCell
        }
        else { //sharedFolders tableview
            let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
            myCell.textLabel!.text = myArray2[indexPath.row]
            return myCell
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        myArray1 = []
        loadDatabase(myFolders)
        myArray2 = []
        loadDatabase(sharedFolders)
        //TODO: need to make these queries different so we are pulling different data
    }

    func loadDatabase(_ folderView: UITableView){
       
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
                    let someName = results.string(forColumn: "name")
                    print("location name is \(String(describing: someName));")
                    if folderView == self.myFolders{
                        myArray1.append(someName!)
                    }
                    else { myArray2.append(someName!)}
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
                      
                        myArray1 = executeUpdate(&myArray1, indexPath)
                    }
                    else{
                        myArray2 = executeUpdate(&myArray2, indexPath)
                    }
                }
                tableView.reloadData()
            }
        }
    }

func executeUpdate(_ array: inout [String], _ indexPath: IndexPath) -> [String]{
    let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
    let folderDB = FMDatabase(path: thepath)
    do{
        let query = "delete from folders where name=?"
        try folderDB.executeUpdate(query, values: [array[indexPath.row]])
        array.remove(at: indexPath.row)
        let ac = UIAlertController(title: "Item deleted", message: "" , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
        //self.present(ac, animated:true, completion:nil)
        //need to fix
        return array
    }
    catch let error as NSError {
        print("error!")
        print("failed \(error)")
    }
    return array
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


