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
        var friendID: Int
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let DB = FMDatabase(path: thepath)
        
        if !(DB.open()) {
            print("Unable to open database")
        } else {
            do{
                let id = UserDefaults.standard.string(forKey: "id")!
                //print("my id \(id)")
                let names = name.text!.split(separator: " ")
                let first = names[0]
                let last = names[1]
                var query = "select userID from users where firstName=?"
                let f = try DB.executeQuery(query, values: [first])
                while(f.next()){
                    friendID = Int(f.int(forColumn: "userID"))
                    print("friend id: \(friendID)")
                    addFriendship(friendID, id)
                }
                
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
        //now, just need to
       
 

    }
    
    func addFriendship(_ friendID: Int, _ id: String){
        print("adding friendship")
    }
}
