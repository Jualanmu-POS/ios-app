//
//  InventoryFirebase.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 14/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

//let id: Int
//let name: String
//let image: String
//let category: String
//let code: String
//let cost: Double
//let margin: Double
//let price: Double
//let currentStock: Int
//let minimumStock: Int
//let shopId: Int
//var userId: String?
//let timeStamp: String

class InventoryFirebase: FirebaseBlueprint {
    
    private var inventory: Inventory!
    
    init() {
        
    }
    
    convenience init(inventory: Inventory) {
        self.init()
        self.inventory = inventory
    }
    
    func key() -> Key {
        return .inventory
    }
    
    func data() -> [String : Any] {
        let dict = [
            "id" : inventory.id,
            "name" : inventory.name,
            "image" : inventory.image,
            "category" : inventory.category,
            "code" : inventory.code,
            "cost" : inventory.cost,
            "margin" : inventory.margin,
            "price" : inventory.price,
            "currentStock" : inventory.currentStock,
            "minimumStock" : inventory.minimumStock,
            "shopId" : inventory.shopId,
            "userId" : inventory.userId,
            "timeStamp" : inventory.timeStamp
        ] as [String : Any]
        return dict
    }
    
    func childs(key: String) -> [String] {
        let uid: String = Preference.getString(forKey: .kUserUid)!
        return [uid]
    }
}
