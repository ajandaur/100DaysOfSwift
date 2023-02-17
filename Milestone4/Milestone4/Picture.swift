//
//  Picture.swift
//  Milestone4
//
//  Created by Anmol  Jandaur on 2/15/23.
//

import Foundation

class PictureImage: NSObject, Codable {
    
    var imageName: String
    var caption: String
    
    
    init(name: String, captionText: String)  {
        self.imageName = name
        self.caption = captionText
    }
}
