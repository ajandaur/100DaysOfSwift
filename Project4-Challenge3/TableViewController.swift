//
//  TableViewController.swift
//  Project4
//
//  Created by Anmol  Jandaur on 2/12/22.
//

import UIKit

class TableViewController: UITableViewController {
    
    var websites = ["apple.com", "hackingwithswift.com", "google.com"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Easy Browser Table"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return websites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteName", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let webViewController = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
            webViewController.websiteToLoad = websites[indexPath.row]
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }

}
