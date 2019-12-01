//
//  AddFolderViewController.swift
//  Mappi
//
//  Created by Leela Ghaemmaghami on 12/1/19.
//  Copyright © 2019 cse438. All rights reserved.
//
import UIKit

class AddFolderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorArray[row]
    }
    var colorArray = ["blue", "red", "green", "purple"]
    
    @IBOutlet weak var colorPicker : UIPickerView!
    @IBOutlet weak var folderName : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorPicker.delegate = self
        self.colorPicker.dataSource = self
        self.colorPicker.reloadAllComponents()
    }
    
    @IBAction func createButton(_ sender: Any) {
        let thisColor = colorArray[colorPicker.selectedRow(inComponent: 0)]
        let thisName = folderName.text!
        
        addFolderToDB(folderName : thisName, color : thisColor)
        let fac = UIAlertController(title: "Successfully created folder", message: "now you can add places from the map", preferredStyle: .alert)
        fac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
        present(fac, animated:true, completion: nil)
    }
    
    func addFolderToDB(folderName : String, color : String){
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let DB = FMDatabase(path: thepath)
        if !(DB.open()) {
            print("Unable to open database")
        } else {
            do{
                let unique = try DB.executeQuery("select * from folders where name=?", values:[folderName])
                if (unique.next() == false){
                    print("folder name unique unique")
                    let myID = UserDefaults.standard.integer(forKey: "id")
                    try DB.executeUpdate("INSERT INTO folders (name, color, owner) VALUES (?, ?, ?)", values:[folderName, color, myID])
                }
                else {
                    print("folder name not unique")
                    let fac = UIAlertController(title: "folder name not unique", message: "Please try again" , preferredStyle: .alert)
                    fac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
                    present(fac, animated:true, completion: nil)
                }
            } catch let error as NSError {
                print("failed \(error)")
            }
        }
    }
}
