//
//  DetailTableViewController.swift
//  Milestone4
//
//  Created by Anmol  Jandaur on 2/17/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!

       var selectedImage: String?
       var photoTitle: String?
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           title = photoTitle
           
           if let imageToload = selectedImage{
               imageView.image = UIImage(named: imageToload)
           }
           
       }

}
