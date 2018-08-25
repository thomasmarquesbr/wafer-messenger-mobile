//
//  ViewController.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

class CountriesViewController: BaseTableViewController, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    var countries = [Country]()
    var filteredCountriesSearch = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()
        getCountries(sender: self)
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }

    }
    
    // MARK: - SearchController
    
    func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.country_currency_or_language
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCountriesSearch = countries.filter({( country: Country) -> Bool in
            return (country.name!.lowercased().contains(searchText.lowercased())) ||
                (country.currencies?.first?.name?.lowercased().contains(searchText.lowercased()))! ||
                (country.languages?.first?.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isFiltering()) ? filteredCountriesSearch.count : countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = (isFiltering()) ? filteredCountriesSearch[indexPath.row] : countries[indexPath.row]
        let currencyName = country.currencies?.first?.name ?? ""
        let languageName = country.languages?.first?.name ?? ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCountry")!
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "\(currencyName) - \(languageName)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction =  UIContextualAction(style: .destructive, title: nil, handler: { (_, _,handler ) in
            if self.isFiltering() {
                let countryToRemove = self.filteredCountriesSearch[indexPath.row]
                self.countries = self.countries.filter({ $0.name != countryToRemove.name })
                self.filteredCountriesSearch.remove(at: indexPath.row)
            } else {
                self.countries.remove(at: indexPath.row)
            }
            handler(true)
        })
        deleteAction.image = #imageLiteral(resourceName: "bomb")
        deleteAction.backgroundColor = Color.primary
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailCountrySegue", let row = tableView.indexPathForSelectedRow?.row {
            let country = (isFiltering()) ? filteredCountriesSearch[row] : countries[row]
            let detailCountryViewController = segue.destination as! DetailCountryViewController
            detailCountryViewController.informations = country.toArray()
            detailCountryViewController.title = country.name
        }
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

extension CountriesViewController: UIViewControllerPreviewingDelegate {
    
    // peek
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else { return nil }
        let country = (isFiltering()) ? filteredCountriesSearch[indexPath.row] : countries[indexPath.row]
        guard let detailCountryViewController = storyboard?.instantiateViewController(withIdentifier: "detailCountryVC") as? DetailCountryViewController else { return nil }
        detailCountryViewController.informations = country.toArray()
        detailCountryViewController.title = country.name
        previewingContext.sourceRect = cell.frame
        return detailCountryViewController
    }
    
    // pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
    }
    
}

