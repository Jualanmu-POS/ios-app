//
//  SoldItemCell.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 18/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class SoldItemCell: UICollectionViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDetailView: UIView!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var soldQtyLabel: UILabel!
    
    var imageRepo = ImageStorageRepo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        itemImage.layer.cornerRadius = 10
        itemDetailView.layer.cornerRadius = 10
        itemDetailView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func setupCell(_ product: ProductReport) {
        if let uid: String = Preference.getString(forKey: .kUserUid){
            let imagePath = "\(uid)/images/inventory/\(product.name).png"
            let placeholderImage = UIImage(named: "leaf")!
            imageRepo.downloadImage(imagePath: imagePath, placeholderImage: placeholderImage, to: itemImage)
            itemImage.contentMode = .scaleAspectFill
        }
    }

}
