//
//  HargaTableViewCell.swift
//  JualanMu
//
//  Created by Hendy Sen on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class HargaTableViewCell: UITableViewCell {

    @IBOutlet weak var hargaLbl: UILabel!
    @IBOutlet weak var hargaTxtField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
