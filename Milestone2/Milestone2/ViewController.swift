//
//  ViewController.swift
//  Milestone2
//
//  Created by Anmol  Jandaur on 4/22/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList: [String] = []

    override func viewDidLoad() {
        
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addItem))
    }
    
    @objc func clearList() {
        let clearAC = UIAlertController(title: "Clear your current list?", message: "", preferredStyle: .alert)
        clearAC.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: restartList))
        present(clearAC, animated: true)
    }
    
    func restartList(action: UIAlertAction!) {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter shopping item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ item: String) {
        shoppingList.insert(item, at: 0)
        
        let indexPath = IndexPath(row:0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    
    


}

