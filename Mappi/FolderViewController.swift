//
//  FolderViewController.swift
//  Mappi
//
//  Created by Gillian Dibbs Laming on 11/4/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadDatabase(){
        
        tableView.reloadData()
        
        let folderDB = Bundle.main.path(forResource: "mappi", ofType: "db")
        
        if !(folderDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
                
                let results = try contactDB.executeQuery("select * from movies", values:nil)
                
                while(results.next()) {
                    let someName = results.string(forColumn: "title")
                    print("movie title is \(String(describing: someName));")
                    myArray.append(someName!)
                    tableView.reloadData()
                    
                    
                    
                }
            } catch let error as NSError {
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
