//
//  CountryCell.swift
//  Countries
//
//  Created by Arber Basha on 29/08/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblCapital: UILabel!
    
    @IBOutlet weak var lblRegion: UILabel!
    

    @IBOutlet weak var lblPopulation: UILabel!
    
    @IBOutlet weak var lblISO: UILabel!
    
    @IBOutlet weak var imgFlag: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
