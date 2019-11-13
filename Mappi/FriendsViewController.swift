//
//  FriendsViewController.swift
//  Mappi
//
//  Created by Gillian Dibbs Laming on 11/4/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    var friends: [String] = ["todd","cole","janegor","leela201","caleb","GILLIAN!!!!!!!!!8734832393023u7SSSSAAAAAAAAAAA"]

    
    @IBOutlet weak var friendView: UITableView!
    var myArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        friendView.dataSource = self
        friendView.delegate = self
        friendView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        friends.sort()
        self.friendView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "hello"
        
        //design for headers
        
        label.backgroundColor = UIColor.yellow
        
        //
        //
        return label
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
        
        myCell.textLabel!.text = myArray[indexPath.row]
             myCell.textLabel!.text = "\(indexPath.section) Row:\(indexPath.row)"
        return myCell
    }
    override func viewWillAppear(_ animated: Bool) {
        myArray = friends
       // loadDatabase(myFolders)
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
                    let query = "delete from friends where userID=? and userID2=?"
                    //TODO: need to lookup the user id based on the display name
                    //remove the friendship from the friends table based on the user id
                    //that we looked up and the user id of the current user
                        //(stored in user defaults)
                    
                    
                    /*try folderDB.executeUpdate(query, values: /*insert vals*/)
                    myArray.remove(at: indexPath.row)
                    let ac = UIAlertController(title: "Item deleted", message: "" , preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
                    present(ac, animated:true, completion:nil)
                    
                    
                } catch let error as NSError {
                    print("error!")
                    print("failed \(error)")
                }*/
            }
            tableView.reloadData()
        }
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
                //TODO: need to grab all the friendships of the current user
                    //(stored in user defaults)
                //then, need to look up display name based on userID from the
                //user table. Add those names to the array to be displayed.
            }
        }
    }

    
}
}
