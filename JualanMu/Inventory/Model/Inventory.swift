//
//  Inventory.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 13/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
struct InventoryItem {
    let title: String
    let required : [Bool]
    let content: [String]
    var item: [String]
}

struct Inventory: Hashable {
    let id: Int
    let name: String
    let image: String
    let category: String
    let code: String
    let cost: Double
    let margin: Double
    let price: Double
    let currentStock: Int
    let minimumStock: Int
    let shopId: String
    let userId: String
    let timeStamp: String
    var key: String
}

class InventoryModel {
    
    let inventory: Inventory!
    
    init?(dict: [String:Any]?) {
        var key: String = ""
        guard
            let dict = dict,
            let id = dict["id"] as? Int,
            let name = dict["name"] as? String,
            let image = dict["image"] as? String,
            let category = dict["category"] as? String,
            let code = dict["code"] as? String,
            let cost = dict["cost"] as? Double,
            let margin = dict["margin"] as? Double,
            let price = dict["price"] as? Double,
            let currentStock = dict["currentStock"] as? Int,
            let minimumStock = dict["minimumStock"] as? Int,
            let shopId = dict["shopId"] as? String,
            let userId = dict["userId"] as? String,
            let timeStamp = dict["timeStamp"] as? String
        else {return nil}
        if let value = dict["key"] as? String {
            key = value
        }
        
        inventory = Inventory(id: id, name: name, image: image, category: category, code: code, cost: cost, margin: margin, price: price, currentStock: currentStock, minimumStock: minimumStock, shopId: shopId, userId: userId, timeStamp: timeStamp, key: key)
            
    }
}
