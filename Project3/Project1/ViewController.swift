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
        
        // loading those NSSL JPEGs was done by scanning the app bundle using the FileManager class, which lets you read and write to the iOS filesystem
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        // The fm was a reference to FileManager and path was a reference to the resource path from Bundle, so this line pulls out an array of files at the directory where our app’s resources lived.
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // CHALLENGE: Sort array of pictures so that file numbers are in order
        for item in items.sorted() {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        // add leftBarButtonItem for app recommendation
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(suggestApp))
    }
    
    @objc func suggestApp() {
        let link = "https://github.com/ajandaur/100DaysOfSwift/tree/main/Project1"
        
        let vc = UIActivityViewController(activityItems: [link], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // That creates a new constant called cell by dequeuing a recycled cell from the table. We have to give it the identifier of the cell type we want to recycle, so we enter the same name we gave Interface Builder: “Picture”.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            
            // CHALLENGE: Use indexPath.row to set selectedPictureNumber
            vc.selectedPictureNumber = indexPath.row + 1
            // CHALLENGE: Set totalPictures using pictures array count
            vc.totalPictures = pictures.count

            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
