//
//  FriendFolderView.swift
//  Mappi
//
//  Created by Gillian Dibbs Laming on 11/4/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class FriendFolderView: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var folderView: UITableView!
    var myArray = [String]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        folderView.dataSource = self
        folderView.delegate = self
        folderView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        self.folderView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
        myCell.textLabel!.text = myArray[indexPath.row]
        return myCell
    }
    override func viewWillAppear(_ animated: Bool) {
        myArray = []
        loadDatabase()
    }
    func loadDatabase(){
        var friendArray = [Int]()
        
        folderView.reloadData()
        
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        
        if !(folderDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
                let results = try folderDB.executeQuery("select * from friends", values:nil)
                
                while(results.next()) {
                    
                    
                    // need to have some conditional
                    let curUserID = results.string(forColumn: "userID")
                    let id = UserDefaults.standard.string(forKey: "id")!
                    if (curUserID == id){
                        let friendID = results.int(forColumn: "friendID")
                        friendArray.append(Int(friendID))
                    }
                    
                        //folderView.reloadData()
                }
                findFriends(friendArray)
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
    }
    func findFriends(_ friendArray: [Int]){
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        if !(folderDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
                for i in friendArray{
                    let query = "select username from users where userID=?"
                    try folderDB.executeUpdate(query, values: friendArray[i])
                    myArray.append(query)
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
