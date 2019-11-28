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
        //UserDefaults.standard.set(id, forKey: "id")
       let id = UserDefaults.standard.string(forKey: "id")!
       /* print("my id \(id)")
        let first = myArray[indexPath.row].split(separator: " ")
        let last = first[1]
        print("first \(first) last \(last)")
        let query = "select userID from users where firstName=?"
        let f = try folderDB.executeQuery(query, values: [first])
        while(f.next()){
            friendID = Int(f.int(forColumn: "userID"))
            print("friend id: \(friendID)")
        }
 */

    }
}
