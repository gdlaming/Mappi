//
//  AddFriendTableViewCell.swift
//  Mappi
//
//  Created by Gillian Dibbs Laming on 11/28/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class AddFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var addFriendButton: UIButton!
   
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    @IBAction func addFriend(_ sender: Any) {
        print("adding friend")
       let friendID = getFriendID()
        print("friendID = \(friendID)")
        if (friendID != 0){
            addFriendship(friendID)
             print("successfully added friend")
//            let alertVC = UIAlertController(title: "Successfullly added!", message: "return to friends to share folders with them.", preferredStyle: .alert)
//            alertVC.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
//            self.inputViewController?.present(alertVC, animated: true, completion: nil)
        }
        else {
            print("error getting friendID")
        }
    }
    
    func getFriendID() -> Int{
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let DB = FMDatabase(path: thepath)
        
        if !(DB.open()) {
            print("Unable to open database")
        } else {
            do{
                let names = name.text!.split(separator: " ")
                let first = names[0]
                //                let last = names[1]
                let query = "select userID from users where firstName=?"
                let f = try DB.executeQuery(query, values: [first])
                if(f.next()){
                    let friendID = Int(f.int(forColumn: "userID"))
                    DB.close()
                    return friendID
                }
            }
            catch let error as NSError {
                print("failed \(error)")
            }
        }
        return 0
    }
    
    func addFriendship(_ friendID: Int){
       print("adding friendship")
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let DB = FMDatabase(path: thepath)
        let myID = UserDefaults.standard.string(forKey: "id")!
        
        if !(DB.open()) {
            print("Unable to open database")
        } else {
            do{
               try DB.executeUpdate("INSERT INTO friends (userID, friendID) VALUES (?, ?)",values:[myID, friendID])

//                let p = try DB.executeQuery("select * from friends where userID=?", values: [myID])
//                while (p.next()){
//                    print("I am friends with user: \(p.int(forColumn: "friendID"))")
//                }
                DB.close()
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
    }
}
