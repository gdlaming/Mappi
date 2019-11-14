//
//  ViewController.swift
//  Mappi
//
//  Created by Gillian Dibbs Laming on 11/3/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var register: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /*check credentials*/
    @IBAction func checkButton(_ sender: Any) {
        if let usern = username.text{
            if let pass = password.text{
                print ("credentials are met!")
                if checkInDB(usern, pass){
                    print ("successful login!")
                    return
                }
                
            }
        }
        print("credentials not met")
        let ac = UIAlertController(title: "Invalid Credentials", message: "Please check your username and password" , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
        present(ac, animated:true, completion:nil)
    }

    func checkInDB(_ username: String, _ password: String) -> Bool {
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let loginDB = FMDatabase(path: thepath)
        
        if !(loginDB.open()) {
            print("Unable to open database")
            return false
        } else {
            do{
                let results = try loginDB.executeQuery("select * from users", values:nil)
                while(results.next()) {
                    let theUsername = results.string(forColumn: "username")
                    if (theUsername == username){
                        //check password -- WE SHOULD HASH PASSWORDS IF WE HAVE TIME
                        let thePassword = results.string(forColumn: "password")
                        if (thePassword == password){
                            let id = results.string(forColumn: "userID")
                            UserDefaults.standard.set(username, forKey: "username")
                            UserDefaults.standard.set(id, forKey: "id")
                            return true
                        }
                    }
                }
            } catch let error as NSError {
                print("failed \(error)")
                return false
            }
            return false
        }
    }
}
