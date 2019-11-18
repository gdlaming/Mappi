//
//  FriendsViewController.swift
//  Mappi
//
//  Created by Gillian Dibbs Laming on 11/4/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
//    var friends: [String] = ["todd","cole","janegor","leela201","caleb","GILLIAN!!!!!!!!!8734832393023u7SSSSAAAAAAAAAAA"]
     var myArray = [String]()
    
    @IBOutlet weak var friendView: UITableView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        friendView.dataSource = self
        friendView.delegate = self
//        friendView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
       // friends.sort()
        self.friendView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        let label = UILabel()
////        label.text = "share folders"
//        
//        //design for headers
//        
//        
//        //
//        //
//        return label
//    }
//    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = friendView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath) as! FriendTableViewCell
        print("entered method")
//        let myCell = friendView.dequeueReusableCell(withIdentifier: "theCell")! as! FriendTableViewCell
        print("setting text")
        myCell.textLabel!.text = myArray[indexPath.row]
        print("set text")
        //myCell.textLabel!.text = "\(indexPath.section) Row:\(indexPath.row)"
        return myCell
    }
    override func viewWillAppear(_ animated: Bool) {
        myArray = []
        loadDatabase()
    }
    
    func findFriends(_ friendArray: [Int]){
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        if !(folderDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
                for friendID in friendArray{
                    let query = "select * from users where userID=?"
                    let f = try folderDB.executeQuery(query, values: [friendID])
                    while(f.next()){
                        let first = f.string(forColumn: "firstName")
                        let last = f.string(forColumn: "lastName")
                            //print("friend name: \(first!) \(last!)")
                        let name: String = first! + " " + last!
                            myArray.append(name)
                    }
                  
                }
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
    }
    
    func loadDatabase(){
        var friendArray = [Int]()
        
        friendView.reloadData()
        
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
                findFriends(friendArray)
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        
        friendView.reloadData()
                //TODO: need to grab all the friendships of the current user
                //(stored in user defaults)
                //then, need to look up display name based on userID from the
                //user table. Add those names to the array to be displayed.
    }
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print(myArray[indexPath.row])
            var friendID = 0
            let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
            let folderDB = FMDatabase(path: thepath)
            
            if !(folderDB.open()) {
                print("Unable to open database")
                return
            } else {
                do{
                    //let query = "delete from friends where userID=? and userID2=?"
                    //TODO: need to lookup the user id based on the display name
                    //remove the friendship from the friends table based on the user id
                    //that we looked up and the user id of the current user
                        //(stored in user defaults)
                    let first = myArray[indexPath.row].split(separator: " ")
                    let last = first[1]
                    print("first \(first) last \(last)")
                    let query = "select userID from users where firstName=?"
                    let f = try folderDB.executeQuery(query, values: [first])
                    while(f.next()){
                        friendID = Int(f.int(forColumn: "userID"))
                        print("friend id: \(friendID)")
                    }
                    let id = UserDefaults.standard.string(forKey: "id")!
                    let query1 = "delete from friends where userID=? and friendID=?"
                    try folderDB.executeUpdate(query1, values: [id, friendID])
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
    var selectedFriendName = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFriendName = myArray[indexPath.item]
        
        performSegue(withIdentifier: "friendViewSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "friendViewSegue")
        {
            let friendVC = segue.destination as? FriendViewController
            
            friendVC?.labelName = selectedFriendName
        }
    }
    
    }


