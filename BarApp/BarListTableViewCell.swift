//
//  BarListTableViewCell.swift
//  BarApp
//
//  Created by Allison Moyer on 2/21/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import UIKit

class BarListTableViewCell: UITableViewCell {

    @IBOutlet weak var barImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(image: UIImage) {
        barImageView.image = image
        barImageView.contentMode = UIViewContentMode.Center
        barImageView.backgroundColor = UIColor(red: (45/255.0), green: (47/255.0), blue: (51/255.0), alpha: 1.0)
        //barImageView.userInteractionEnabled = true
        
    }

}
