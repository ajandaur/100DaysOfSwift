//
//  ViewController.swift
//  Project12
//
//  Created by Anmol  Jandaur on 5/16/22.
//

import UIKit

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseTouchID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        defaults.set("Paul Hudson", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        let array = ["Hello", "World"]
        defaults.set(array, forKey: "SavedArray")
        let dict = ["Name":"Paul","Country":"UK"]
        defaults.set(dict, forKey: "SavedDict")
        
        let savedArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        let savedDict = defaults.object(forKey: "SavedDict") as? [String: String] ?? [String: String]()
    }


}

