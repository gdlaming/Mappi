//
//  SharedFolderViewController.swift
//  Mappi
//
//  Created by Cole Makuch on 11/17/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class SharedFolderViewController: UIViewController {

    @IBOutlet weak var placesTable: UITableView!
    @IBOutlet weak var IDLabel: UILabel!
  
    
//    var iDLabelName = ""
    func updateValues(){
//        IDLabel.text = iDLabelName
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateValues()

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = placesTable.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! FolderTableViewCell
        print("entered method")
        //        let myCell = friendView.dequeueReusableCell(withIdentifier: "theCell")! as! FriendTableViewCell
        print("setting text")
        //        myCell.textLabel!.text = myArray[indexPath.row]
        print("set text")
        //myCell.textLabel!.text = "\(indexPath.section) Row:\(indexPath.row)"
        return myCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
