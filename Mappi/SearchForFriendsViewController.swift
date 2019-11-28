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
        myArray.append("Gillian")
        self.searchBar.delegate = self
        friendView.dataSource = self
        friendView.delegate = self
        //searchBar.returnKeyType = UIReturnKeyType.done
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = friendView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! UITableViewCell
        //        let myCell = friendView.dequeueReusableCell(withIdentifier: "theCell")! as! FriendTableViewCell
       // print("setting text")
        myCell.textLabel!.text = myArray[indexPath.row]
        //print("set text")
        //myCell.textLabel!.text = "\(indexPath.section) Row:\(indexPath.row)"
        return myCell
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //let query = searchBar.text!
        print("hello, world!")
        fetchDataFromSearch()
    }
    
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
//        query = searchBar.text!
//        fetchDataFromSearch()
//    }
    
    func fetchDataFromSearch(){
        print(query)
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
