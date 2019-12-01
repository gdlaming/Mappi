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
            editButton.titleLabel?.text = "done"
            editButtonActive = true
        }
        if editButtonActive == true{
            placeDescriptionText.backgroundColor = UIColor.white
            editButton.titleLabel?.text = "edit"
            descriptionText.isEditable = false
        }
    
        
    }
    
    @IBOutlet weak var descriptionText: UITextView!
    var editButtonActive = false
    
}
