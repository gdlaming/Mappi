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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkButton(_ sender: Any) {
        //need to check:
            //if all the fields are filled out
            //if the username is unique
            //if the passwords match
        //if everything checks out, return to login page
       //  let vc = LoginViewController()
        
        
        let ac = UIAlertController(title: "Successful Registration!", message: "Please login now" , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title:"Login", style: .default, handler:nil))
        present(ac, animated:true, completion: nil)
        //TODO: take back to login page
            //could use a segue or present view controller
        
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
