//
//  EmptyViewCell.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 09/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class EmptyViewCell: UITableViewCell {

    @IBOutlet weak var emptyView: EmptyView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(title: String, subtitle: String, image: String, buttonTitle: String) {
        emptyView.setupView(title: title, subtitle: subtitle, image: image, buttonTitle: buttonTitle)
    }
}
