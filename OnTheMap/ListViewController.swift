//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Abdalla Tawfik on 7/30/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Update UI
    
    override func updateUI() {
        tableView.reloadData()
    }
}

// MARK: - ListViewController (TableView) datasource and delegate

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.TableViewCell) as UITableViewCell!
        
        let studentInformation = studentInformations[indexPath.row]
        
        cell?.textLabel!.text = studentInformation.getFullName()
        cell?.detailTextLabel?.text = studentInformation.mediaURL
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInformation = studentInformations[indexPath.row]
        if let url = URL(string: studentInformation.mediaURL) {
            openURL(url)
        }
    }
}
