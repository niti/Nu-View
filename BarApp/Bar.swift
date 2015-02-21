//
//  Bar.swift
//  BarApp
//
//  Created by Allison Moyer on 2/17/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import Foundation
import UIKit

struct Bar {
    var title: String?
    //var description: String?
    var icon: UIImage?
    var imageNamesArray: [String] = []
    
    init(index: Int){
        let barsLibrary = BarLibrary().library
        let barDictionary = barsLibrary[index]
                
        imageNamesArray = ["image0.png", "image1.png", "image2.png", "image3.png", "image4.png"]

        
        //title = barDictionary["title"] as String!
        //description = playlistDictionary["description"] as String!
        
        let iconName = barDictionary["icon"] as String!
        icon = UIImage(named: iconName)
        //imageNamesArray = barDictionary["images"] as [String]
        
        //let largeIconName = playlistDictionary["largeIcon"] as String!
        //largeIcon = UIImage(named: largeIconName)
        
        //artists += playlistDictionary["artists"] as [String]
        
        //let colorDictionary = playlistDictionary["backgroundColor"] as [String: CGFloat]!
        //backgroundColor = rgbColorFromDictionary(colorDictionary)
        
    }
    
}