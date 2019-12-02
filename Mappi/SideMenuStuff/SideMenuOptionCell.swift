 //
//  SideMenuOptionCell.swift
//  Mappi
//
//  Created by Caleb Diaz on 11/19/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit
import MapKit

class SideMenuOptionCell: UITableViewCell {
    //MARK: Properties
    
    let folderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    //MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        //Pt 2 4:00
        addSubview(folderLabel)
        folderLabel.translatesAutoresizingMaskIntoConstraints = false
        folderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        folderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Handlers
}
