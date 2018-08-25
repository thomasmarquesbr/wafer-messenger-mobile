//
//  DetailCountryViewController.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 25/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

class DetailCountryViewController: BaseTableViewController {
    
    var informations = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = informations[indexPath.row].components(separatedBy: ":")
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCoutryCell") as! UITableViewCell
        cell.textLabel?.text = item[0]
        cell.detailTextLabel?.text = item[1]
        cell.selectionStyle = .none
        return cell
    }
    
}
