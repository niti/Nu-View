//
//  BarDetailTableViewCell.swift
//  BarApp
//
//  Created by Allison Moyer on 2/18/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import UIKit

class BarDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var barDetailImageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(image: String) {
        barDetailImageCell.image = UIImage(named: image)
    }

}
