//
//  TopEventCell.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 20/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class TopEventCell: UITableViewCell {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var totalProfitLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
