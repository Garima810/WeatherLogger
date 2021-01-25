//
//  DetailTableViewCell.swift
//  WeatherBlogger
//
//  Created by Garima Ashish Bisht on 25/01/21.
//  Copyright © 2021 Garima Kushwah. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblLeftTitle: UILabel!
    @IBOutlet weak var leftDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblLeftTitle.textColor = UIColor.white
        leftDescription.textColor = UIColor.white
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
