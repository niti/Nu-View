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
        
        //var barTitle: String = PFCloud.callFunction("getBarTitle", withParameters: ["index" : index])
        //var barIcon: String = PFCloud.callFunction("getBarIcon", withParameters: ["index" : index])

                
        title = barDictionary["title"] as String!
        let iconName = barDictionary["icon"] as String!
        icon = UIImage(named: iconName)

        
    }
    
}