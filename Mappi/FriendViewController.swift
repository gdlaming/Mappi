//
//  FriendViewController.swift
//  Mappi
//
//  Created by Cole Makuch on 11/17/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController {

    
    var myArray = [String]()
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mapPicker: UIPickerView!
    @IBOutlet weak var shareButton: UIButton!
    
    
    var labelName = ""
    
    func updateValues(){
        nameLabel.text = labelName
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateValues()
//        findFolders(<#T##folderArray: [Int]##[Int]#>)
        // Do any additional setup after loading the view.
    }
    
    func findFolders(_ folderArray: [Int]){
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let folderDB = FMDatabase(path: thepath)
        if !(folderDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
//                for friendID in folderArray{
                for folderID in folderArray{
                    let query = "select * from users where userID=?"
                    let f = try folderDB.executeQuery(query, values: [folderID])
                    while(f.next()){
                        let folder = f.string(forColumn: "name")
                print (String(folder!))
                        //print("friend name: \(first!) \(last!)")
//                        let name: String = first! + " " + last!
                        myArray.append("test1")
                        myArray.append("test 2")
                        myArray.append(String(folder!))
                    }
                    
                }
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
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
