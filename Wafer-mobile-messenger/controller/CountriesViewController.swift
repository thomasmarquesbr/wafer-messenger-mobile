//
//  ViewController.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

/**
 ViewController responsible for displaying the entire list of Countries
 **/
class CountriesViewController: BaseTableViewController, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    var countries = [Country]()
    var filteredCountriesSearch = [Country]()
    
    // Configura SerachBarController, Inicializa requisição ao servidor e habilita 3D touch se possível
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()
        getCountries(sender: self)
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }

    }
    
    // MARK: - SearchController
    
    // Configure searchBarController
    func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.country_currency_or_language
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        definesPresentationContext = true
    }
    
    // Checks whether SearchBar is empty or not
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Compares the string typed in the SearchBar with the name of the country, first name if there is currency or the first current language if there is
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCountriesSearch = countries.filter({( country: Country) -> Bool in
            return (country.name!.lowercased().contains(searchText.lowercased())) ||
                (country.currencies?.first?.name?.lowercased().contains(searchText.lowercased()))! ||
                (country.languages?.first?.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    // Updates results according to text typed in SearchBar
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    // Checks if a search is currently being performed to perform operations on the TableView
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
    
    // Constructs each cell title with country name, subtitle with the first currency and first language if it exists in the model
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
    
    // Creates swipe action to the left with a custom pump icon and allows deletion of the cell as it slides all the way to the left. The country is removed from both the default list and the filtered list if possible
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction =  UIContextualAction(style: .destructive, title: nil, handler: { (_, _,handler ) in
            self.removeCountry(index: indexPath.row)
            handler(true)
        })
        deleteAction.image = #imageLiteral(resourceName: "bomb")
        deleteAction.backgroundColor = Color.primary
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // Function responsible for swipe action on devices with lower IOS 11.0
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "") { action, index in
            self.removeCountry(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.backgroundColor = UIColor(patternImage: actionCellImage())
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Segue
    
    // Configures parameters of the next ViewController that will be called when clicking a TableViewCell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailCountrySegue", let row = tableView.indexPathForSelectedRow?.row {
            let country = (isFiltering()) ? filteredCountriesSearch[row] : countries[row]
            let detailCountryViewController = segue.destination as! DetailCountryViewController
            detailCountryViewController.informations = country.toArray()
            detailCountryViewController.title = country.name
        }
    }
    
    // MARK: - Functions
    
    // Check Internet connection availability and then Make a call to DataManager to load the list of Countries
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
    
    func removeCountry(index: Int) {
        if self.isFiltering() {
            let countryToRemove = self.filteredCountriesSearch[index]
            self.countries = self.countries.filter({ $0.name != countryToRemove.name })
            self.filteredCountriesSearch.remove(at: index)
        } else {
            self.countries.remove(at: index)
        }
    }
    
    // Configure image for editRow in devices with IOS 10 or lower
    func actionCellImage() -> UIImage {
        let commonWid : CGFloat = 40
        let commonHei : CGFloat = 70 // EACH ROW HEIGHT
        UIGraphicsBeginImageContextWithOptions(CGSize(width: commonWid, height: commonHei), false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(Color.primary.cgColor)
        context!.fill(CGRect(x: 0, y: 0, width: commonWid, height: commonHei))
        var img: UIImage = UIImage(named: "bomb")!
        img.draw(in: CGRect(x: 4, y: 7, width: 30, height: 30))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

/**
 Extends the class to support Peek and Pop 3D Touch available on the IOS device
 **/
extension CountriesViewController: UIViewControllerPreviewingDelegate {
    
    // Peek: Displays a preview of a particular configured ViewController
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else { return nil }
        let country = (isFiltering()) ? filteredCountriesSearch[indexPath.row] : countries[indexPath.row]
        guard let detailCountryViewController = storyboard?.instantiateViewController(withIdentifier: "detailCountryVC") as? DetailCountryViewController else { return nil }
        detailCountryViewController.informations = country.toArray()
        detailCountryViewController.title = country.name
        previewingContext.sourceRect = cell.frame
        return detailCountryViewController
    }
    
    // Pop: When you end the pressure on the screen, it opens a certain configured ViewController
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
    }
    
}

