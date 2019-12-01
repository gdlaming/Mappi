//
//  FolderTableViewCell.swift
//  Mappi
//
//  Created by Cole Makuch on 11/17/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {

    @IBOutlet weak var placeTitleLabel: UILabel!
    
    @IBOutlet weak var placeDescriptionText: UITextView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editButton(_ sender: Any) {
        if editButtonActive == false{
            descriptionText.isEditable = true
            placeDescriptionText.backgroundColor = UIColor.lightGray
            editButton.setTitle ("done", for: .normal)
            editButtonActive = true
            return
        }
        if editButtonActive == true{
            updateDB()
            descriptionText.isEditable = false
            placeDescriptionText.backgroundColor = UIColor.white
            editButton.setTitle ("edit", for: .normal)
            editButtonActive = false
            return
        }
    }
    
    func updateDB(){
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let DB = FMDatabase(path: thepath)
        let placeName = placeTitleLabel.text!
        let description = placeDescriptionText.text!
        
        if !(DB.open()) {
            print("Unable to open database")
        } else {
            do{
                let results = try DB.executeQuery("select * from places where locationName=?", values:[placeName])
                while (results.next()){
                    // insert all info into db
                    try DB.executeUpdate("UPDATE places SET description=? WHERE locationName=?", values:[description, placeName])
                    print("updated desc in db")
                }
            } catch let error as NSError {
                print("failed \(error)")
            }
        }
    }
    
    @IBOutlet weak var descriptionText: UITextView!
    var editButtonActive = false
    
}
