//
//  ProductListCell.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 07/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SDWebImage

class ProductListCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemDetailView: UIView!
    @IBOutlet weak var coverView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupProductList(_ product: Product,_ imageRepo: ImageStorageRepo) {
        itemImage.layer.cornerRadius = 12
        itemDetailView.layer.cornerRadius = 12
        itemDetailView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        itemNameLabel.text = product.name
        priceLabel.text = "\(product.price.currencyFormat())"
        
        if product.image != "" {
            // Placeholder image
            let placeholderImage = UIImage(named: "leaf")!
            imageRepo.downloadImage(imagePath: product.image, placeholderImage: placeholderImage, to: itemImage)
            itemImage.contentMode = .scaleAspectFill
        }
        
        coverView.isHidden = !product.isSelected
        coverView.setupRadius(type: .custom(12.0))
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
