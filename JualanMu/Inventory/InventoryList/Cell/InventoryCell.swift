//
//  TableViewCell.swift
//  JualanMu
//
//  Created by Hendy Sen on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SDWebImage

protocol InventoryDelegate:class {
    func deleteItem(index: Int)
}

class InventoryCell: UITableViewCell {

    @IBOutlet weak var imageBarang: UIImageView!
    @IBOutlet weak var namaBarang: UILabel!
    @IBOutlet weak var hargaBarang: UILabel!
    @IBOutlet weak var skuBarang: UILabel!
    @IBOutlet weak var stockBarang: UILabel!
    
    weak var delegate: InventoryDelegate?
    var index: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupInventory(_ inventory: Inventory,_ imageRepo: ImageStorageRepo) {
        namaBarang.text = inventory.name
        hargaBarang.text = "\(inventory.price.currencyFormat())"
        skuBarang.text = "SKU \(inventory.code)"
        stockBarang.text = "Stok: \(inventory.currentStock)"
        
        if inventory.image != "" {
            let placeholderImage = UIImage(named: "leaf")!
            imageRepo.downloadImage(imagePath: inventory.image, placeholderImage: placeholderImage, to: imageBarang)
            imageBarang.contentMode = .scaleAspectFill
        }
        
        imageBarang.setupRadius(type: .custom(10.0))
        imageBarang.setupBorder()
        
        if inventory.currentStock < 1 {
            stockBarang.textColor = .systemRed
        } else {
            stockBarang.textColor = .black
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.deleteItem(index: index)
    }
    
    func setNotification(_ message: String) {
        let manager = LocalNotificationManager()
        manager.addNotification(title: message)
        manager.schedule()
    }
}
