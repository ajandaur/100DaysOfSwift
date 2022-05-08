//
//  ViewController.swift
//  Project1
//
//  Created by Anmol  Jandaur on 5/16/20.
//  Copyright © 2020 Anmol  Jandaur. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true

        performSelector(inBackground: #selector(loadPictures), with: nil)
        collectionView.performSelector(onMainThread: #selector(collectionView.reloadData), with: nil, waitUntilDone: false)

    }
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // CHALLENGE: Sort array of pictures so that file numbers are in order
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for:  indexPath) as? ImageCell else {
            fatalError("Unable to dequeue ImageCell")
        }
        
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        let picture = pictures[indexPath.item]
        
        cell.name.text = picture.description
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.item]
            
            // CHALLENGE: Use indexPath.row to set selectedPictureNumber
            vc.selectedPictureNumber = indexPath.row + 1
            // CHALLENGE: Set totalPictures using pictures array count
            vc.totalPictures = pictures.count

            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }


}
