//
//  LaporanCollectionCell.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 15/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class LaporanCollectionCell: UICollectionViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDetailView: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    
    var imageRepo: ImageStorageRepo = ImageStorageRepo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        itemImage.layer.cornerRadius = 10
        itemDetailView.layer.cornerRadius = 10
        itemDetailView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func setupCell(_ product: ProductReport) {
        itemLabel.text = product.sku
        if let uid: String = Preference.getString(forKey: .kUserUid){
            let imagePath = "\(uid)/images/inventory/\(product.name).png"
            let placeholderImage = UIImage(named: "leaf")!
            imageRepo.downloadImage(imagePath: imagePath, placeholderImage: placeholderImage, to: itemImage)
            itemImage.contentMode = .scaleAspectFill
        }
    }

}
