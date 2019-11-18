//
//  SharedFolderViewController.swift
//  Mappi
//
//  Created by Cole Makuch on 11/17/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class SharedFolderViewController: UIViewController {

    @IBOutlet weak var IDLabel: UILabel!
    
    
    var iDLabelName = ""
    func updateValues(){
        IDLabel.text = iDLabelName
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateValues()

        // Do any additional setup after loading the view.
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
