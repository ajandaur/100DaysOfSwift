//
//  ViewController.swift
//  Project1
//
//  Created by Anmol  Jandaur on 5/16/20.
//  Copyright © 2020 Anmol  Jandaur. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl")
            {
                //this is a picture to load!!
                pictures.append(item)
            }
            pictures.sort()
        }
        print(pictures)
        
        }
    
    //want one cell for each picture
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController
            //All optionals might fail in this one line above
            //if any of those things fail, code inside the braces won't execute
            //gurantees program is in a space state 
        {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row+1
            vc.totalPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

