//
//  PhotoTableViewCell.swift
//  JualanMu
//
//  Created by Hendy Sen on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

protocol PhotoTableViewCellDelegate {
    func selectImage(_ sender: UIView)
}

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgBarang: UIImageView!
    var delegate: PhotoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgBarang.layer.cornerRadius = 10
        imgBarang.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //remove cell separator
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews where view != contentView {
            view.removeFromSuperview()
        }
    }
    
    @IBAction func changeImageButton(_ sender: UIButton) {
        delegate?.selectImage(imgBarang)
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer){
        delegate?.selectImage(imgBarang)
    }
}
