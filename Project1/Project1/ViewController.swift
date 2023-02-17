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
    
    var pictureDict = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true

        performSelector(inBackground: #selector(loadPictures), with: nil)
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)

    }
    
    func save()  {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictureDict), let savedPictures = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictDict")
            defaults.set(savedPictures, forKey: "pictures")
        } else {
            print("Failed to save pictures")
        }
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // CHALLENGE: Sort array of pictures so that file numbers are in order
        for item in items.sorted() {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                pictureDict[item] = 0
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            guard let rows = tableView.dequeueReusableCell(withIdentifier: "cellPicture", for: indexPath) as? CaptionedPhoto else{
                fatalError("something went wrong with deque")
            }

            let person = pictures[indexPath.row]
            let path = getDocumentsDirectory().appendingPathComponent(person.photo)
            rows.imageView?.image = UIImage(contentsOfFile: path.path)

            //either go here
    //        rows.caption.text = person.caption

            let ac = UIAlertController(title: "Add captions to this photo", message: nil, preferredStyle: .alert)
            ac.addTextField()

            ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "add", style: .default) {[weak self, weak ac] _ in
                guard let newLabel = ac?.textFields?[0].text else{ return }
                person.caption = newLabel
                self?.tableView.reloadData()
            }

            )
            present(ac, animated: true)

            rows.caption.text = person.caption
            return rows
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
        
        // increment the # of times the picture is being viewed
        let picture = pictures[indexPath.row]
        pictureDict[picture]! += 1
        save()
        tableView.reloadData()
    }
}
