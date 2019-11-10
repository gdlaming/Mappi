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
            //if all the fields are filled out
            //if the username is unique
            //if the passwords match
        //if everything checks out, alert the user that
        //  registration was successful and return to login page
        
        let ac = UIAlertController(title: "Successful Registration!", message: "Please login now" , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title:"Login", style: .default, handler:nil))
        present(ac, animated:true, completion: nil)
        
        //TODO: take back to login page
            //could use a segue or present view controller
        
    }

}
