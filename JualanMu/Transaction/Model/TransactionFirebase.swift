//
//  TransactionFirebase.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 15/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
class TransactionFirebase: FirebaseBlueprint {
    
    private var transaction: Transaction!
    
    init() {
        
    }
    
    convenience init(transaction: Transaction) {
        self.init()
        self.transaction = transaction
    }
    
    func key() -> Key {
        .transaction
    }
    
    func data() -> [String : Any] {
        return [
            "id":transaction.id,
            "total":transaction.total,
            "invoice":transaction.invoice,
            "change":transaction.change,
            "cash":transaction.cash,
            "userId":transaction.userId,
            "shopId":transaction.shopId,
            "timeStamp":transaction.timestamp,
            "eventId":transaction.eventId
        ]
    }
    
    func childs(key: String) -> [String] {
        let uid: String = Preference.getString(forKey: .kUserUid)!
        return [uid]
    }
    
}
