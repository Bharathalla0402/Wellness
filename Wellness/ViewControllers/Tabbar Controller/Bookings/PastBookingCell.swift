//
//  PastBookingCell.swift
//  Wellness
//
//  Created by think360 on 09/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class PastBookingCell: UITableViewCell
{
    @IBOutlet weak var BookingImage: UIImageView!
    @IBOutlet weak var BookingStoreName: UILabel!
    @IBOutlet weak var BookingName: UILabel!
    @IBOutlet weak var BookingDate: UILabel!
    @IBOutlet weak var BookingTime: UILabel!
    @IBOutlet weak var BookingPrice: UILabel!
    @IBOutlet weak var PreScheduleBookButt: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
