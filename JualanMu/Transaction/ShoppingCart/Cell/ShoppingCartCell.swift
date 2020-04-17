//
//  ShoppingCartCell.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 11/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SDWebImage


protocol CartDelegate: class {
    func onAddTapped(index: Int)
    func onReduceTapped(index: Int)
    func onDeleteTapped(index: Int)
}

class ShoppingCartCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var minButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: CartDelegate?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCart(delegate: CartDelegate, index: Int, product: Product, imageRepo: ImageStorageRepo) {
        itemImage.layer.cornerRadius = 10
        itemName.text = product.name
        itemPrice.text = product.price.currencyFormat()
        quantity.text = "\(product.quantity)"
        self.delegate = delegate
        self.index = index
        if product.image != "" {
            let placeholderImage = UIImage(named: "leaf")!
            imageRepo.downloadImage(imagePath: product.image, placeholderImage: placeholderImage, to: itemImage)
            itemImage.contentMode = .scaleAspectFill
        }
    }
    
    @IBAction func onDeleteTapped(_ sender: Any) {
        delegate?.onDeleteTapped(index: index ?? 0)
    }
    
    @IBAction func onReduceTapped(_ sender: Any) {
        delegate?.onReduceTapped(index: index ?? 0)
    }
    
    @IBAction func onAddTapped(_ sender: Any) {
        delegate?.onAddTapped(index: index ?? 0)
    }
}
