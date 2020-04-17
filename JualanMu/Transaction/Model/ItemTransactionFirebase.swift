//
//  ItemTransactionFirebase.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 15/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
class ItemTransactionFirebase: FirebaseBlueprint {
    
    private var itemTransaction: ItemTransaction!
    
    init() {
        
    }
    
    convenience init(itemTransaction: ItemTransaction) {
        self.init()
        self.itemTransaction = itemTransaction
    }
    
    func key() -> Key {
        return .item_transaction
    }
    
    func data() -> [String : Any] {
        return [
            "id":itemTransaction.id,
            "itemName":itemTransaction.itemName,
            "itemCode":itemTransaction.itemCode,
            "productId":itemTransaction.productId,
            "price":itemTransaction.price,
            "quantity":itemTransaction.quantity,
            "timestamp":itemTransaction.timestamp,
            "transactionId":itemTransaction.transactionId
        ]
    }
    
    func childs(key: String) -> [String] {
        let uid: String = Preference.getString(forKey: .kUserUid)!
        return [uid]
    }
    
    
}
