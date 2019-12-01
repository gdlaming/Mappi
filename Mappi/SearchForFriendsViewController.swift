//
//  SearchForFriendsViewController.swift
//  Mappi
//
//  Created by Cole Makuch on 11/18/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class SearchForFriendsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var friendView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var myArray = [String]()
    
    var query = "search for your friends here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        friendView.dataSource = self
        friendView.delegate = self
        friendView.reloadData()
        //searchBar.returnKeyType = UIReturnKeyType.done
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = friendView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! AddFriendTableViewCell

        myCell.name.text = myArray[indexPath.row]

        return myCell
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        query = searchBar.text!
        print(query)
        fetchDataFromSearch()
    }
    
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
//        query = searchBar.text!
//        fetchDataFromSearch()
//    }
    
    func fetchDataFromSearch(){
        var found=false;
        let thepath = Bundle.main.path(forResource: "mappi", ofType: "db")
        let DB = FMDatabase(path: thepath)
        if !(DB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
                let friendResults = try DB.executeQuery("select * from users where username=?", values:[query])
                while(friendResults.next()){
                    let first = String(friendResults.string(forColumn: "firstName")!)
                    let last = String(friendResults.string(forColumn: "lastName")!)
                    let combined = first + " " + last
                    found = true;
                    myArray.append(combined)
                }
                if (!found){
                    let ac = UIAlertController(title: "No results", message: "No friends found for the name entered" , preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title:"Return", style: .default, handler:nil))
                    present(ac, animated:true, completion:nil)
                }
                DB.close()
            }
            catch let error as NSError {
                print("failed \(error)")
                
            }
        }
        friendView.reloadData()
        for item in myArray{
            print(item)
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


