//
//  ConsumptionTableViewCell.swift
//  Energy
//
//  Created by Simon Orlovsky on 5/20/15.
//  Copyright (c) 2015 simonorlovsky. All rights reserved.
//

import UIKit

class ConsumptionTableViewCell: UITableViewCell {

    @IBOutlet var buildingImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
