//
//  ViewController.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

class CountriesViewController: UITableViewController {

    var coutries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountries()
    }
    
    // MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coutries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = coutries[indexPath.row]
        let currencyName = country.currencies?.first?.name ?? ""
        let languageName = country.languages?.first?.name ?? ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCountry") as! UITableViewCell
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "\(currencyName) - \(languageName)"
        return cell
    }
    
    // MARK: - Functions
    
    func getCountries() {
        DataManager().getCountries { (countries) in
            self.coutries = countries
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    

}
