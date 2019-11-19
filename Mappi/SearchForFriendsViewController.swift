//
//  SearchForFriendsViewController.swift
//  Mappi
//
//  Created by Cole Makuch on 11/18/19.
//  Copyright © 2019 cse438. All rights reserved.
//

import UIKit

class SearchForFriendsViewController: UIViewController, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    var query = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        query = searchBar.text!
        fetchDataFromSearch()
    }
    
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
