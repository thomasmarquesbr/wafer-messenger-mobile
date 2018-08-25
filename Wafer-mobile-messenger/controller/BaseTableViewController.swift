//
//  BaseTableViewController.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

/**
 Base class for in-app use of TableViews. Responsible for implementing load components, display of user messages and default settings of the application's own TableView
 **/
class BaseTableViewController: UITableViewController {
    
    private let label = UILabel()
    private let loadingView = UIView()
    private let loadingLabel = UILabel()
    private let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: Color.primary]
        } 
    }
    
    // Displays informational message to the user about the loading state of the tableview and allows reloading by touching the UILabel created with the selector: RefreshAction
    func show(message: String, refreshAction: Selector) {
        label.removeFromSuperview()
        stopLoading()
        let width: CGFloat = 250
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        label.frame = CGRect(x: x, y: y, width: width, height: height)
        label.text = message
        label.textAlignment = .center
        label.textColor = .gray
        let tap = UITapGestureRecognizer(target: self, action: refreshAction)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        tableView.addSubview(label)
    }
    
    // Displays activityIndicator and a UILabel with table loading message for user
    func startLoading() {
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = Constants.loading
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        tableView.addSubview(loadingView)
    }
    
    // Stop showing any loading message or activityIndicator.
    func stopLoading() {
        label.removeFromSuperview()
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        spinner.removeFromSuperview()
        loadingLabel.removeFromSuperview()
        loadingView.removeFromSuperview()
    }

    
}
