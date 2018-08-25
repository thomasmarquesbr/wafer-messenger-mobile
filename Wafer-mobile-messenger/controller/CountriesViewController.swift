//
//  ViewController.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

class CountriesViewController: BaseTableViewController {

    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountries(sender: self)
    }
    
    // MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = countries[indexPath.row]
        let currencyName = country.currencies?.first?.name ?? ""
        let languageName = country.languages?.first?.name ?? ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCountry") as! UITableViewCell
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "\(currencyName) - \(languageName)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - Functions
    
    @objc func getCountries(sender: AnyObject) {
        if !Reachability.isConnectedToNetwork() {
            show(message: Constants.no_connection, refreshAction: #selector(CountriesViewController.getCountries))
            return
        }
        startLoading()
        DataManager().getCountries { (countries) in
            self.countries = countries
            OperationQueue.main.addOperation {
                self.stopLoading()
                if self.countries.count == 0 {
                    self.show(message: Constants.empty_countries_list, refreshAction: #selector(CountriesViewController.getCountries))
                }
                self.tableView.reloadData()
            }
        }
    }
    

}
