//
//  ViewController.swift
//  Project7
//
//  Created by Anmol  Jandaur on 4/24/22.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Challenge 1
        configureRightBarButton()
        
        // Challenge 2
        configureLeftBarButtons()

        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
        filteredPetitions = petitions
        
    }
    
    @objc func fetchJSON() {
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }


        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func configureLeftBarButtons() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetList))
        
        navigationItem.leftBarButtonItems = [filterButton, resetButton]
    }
    
    func configureRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
    }
    
    @objc func resetList() {
        filteredPetitions = petitions
        tableView.reloadData()
    }
    
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Filter petitions", message: "Type in the filter..", preferredStyle: .alert)
        ac.addTextField()
        
        // Create a UIAlertAction.. using trailing closure syntax
        
        // self = current VC, ac = UIAlertController, both are captured as WEAK REFERENCE inside the closure
        // This means the closure can use them, but won't create a strong reference because we've made it clear the
        // closure doesn't own either of them
        
        // Background thread
        DispatchQueue.global(qos: .background).async {
            
        }
        let filterAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak ac] _ in
            //  we're giving the UIAlertAction some code to execute when it is tapped, and it wants to know that that code accepts a parameter of type UIAlertAction
            guard let filterWord = ac?.textFields?[0].text else { return }
            self?.performSelector(inBackground: #selector(self?.displayPetitions(for: )), with: filterWord)
            
            self?.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
        
        // This attaches an action object to the alert
        ac.addAction(filterAction)
        
        // Then we finally present our alert controller to the user
        present(ac, animated: true)
    }
    
    @objc func displayPetitions(for filter: String) {
        filteredPetitions = filteredPetitions.filter { $0.title.contains(filter) }
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "This data is from We The People API of the Whitehouse", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func showError() {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    
}

