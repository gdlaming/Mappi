//
//  RegisterViewController.swift
//  Mappi
//
//  Created by Gillian Dibbs Laming on 11/9/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func checkButton(_ sender: Any) {
        //TODO: need to check:
        let usern = username.text!
        let first = firstName.text!
        let last = lastName.text!
        let pass1 = password1.text!
        let pass2 = password2.text!
            //if all the fields are filled out
        if usern != ""{
            if first != ""{
            if last != ""{
            if pass1 != ""{
            if pass2 != ""{
                print ("filled all boxes")
                if (pass1 == pass2){    //if the passwords match
                //   call helper function here
                    if register(usern, first, last, pass1){
                        print("successful registration!")
                        let ac = UIAlertController(title: "Successful Registration!", message: "Please login now" , preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title:"Login", style: .default, handler:{ action in self.performSegue(withIdentifier: "loginSegue", sender: self) }))
                        present(ac, animated:true, completion: nil)
                        
                    } else {
                        let fac = UIAlertController(title: "Unsuccessful Registration", message: "Please try again" , preferredStyle: .alert)
                        fac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
                        present(fac, animated:true, completion: nil)
                    }
                } else {
                    let fac = UIAlertController(title: "Passwords Don't Match", message: "Please try again" , preferredStyle: .alert)
                     fac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
                    present(fac, animated:true, completion: nil)
                }
            } else { missingAlert("password confimation")}
            } else { missingAlert("password")}
            } else { missingAlert("last name")}
            } else { missingAlert("first name")}
        } else { missingAlert("username")}
    }
    
    func missingAlert(_ missing: String){
        let fac = UIAlertController(title: "Missing \(missing)", message: "Please try again" , preferredStyle: .alert)
        fac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
        present(fac, animated:true, completion: nil)
    }
    
    
    func register(_ usern: String, _ first: String, _ last: String, _ pass: String) -> Bool{
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let loginDB = FMDatabase(path: thepath)
        
        if !(loginDB.open()) {
            print("Unable to open database")
            return false
        } else {
            do{
            //check if the username is unique by making sure nothing is returned when selecting where username = username
            let unique = try loginDB.executeQuery("select * from users where username=?", values:[usern])
                if (unique.next() == false){
                    print("username unique")
                    // insert all info into db
                    try loginDB.executeUpdate("INSERT INTO users (username, firstName, lastName, password) VALUES (?, ?, ?, ?)", values:[usern, first, last, pass])
                    return true
                }
                else {
                    print("username not unique")
                    let fac = UIAlertController(title: "username not unique", message: "Please try again" , preferredStyle: .alert)
                    fac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
                    present(fac, animated:true, completion: nil)
                }
            } catch let error as NSError {
                print("failed \(error)")
                return false
            }
        return false
        }
    }
}
