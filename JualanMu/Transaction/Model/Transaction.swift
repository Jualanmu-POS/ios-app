//
//  Transaction.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 15/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

//Transaksi
//⁃Id Transaksi (PK FK)
//⁃Total transaksi (Int, NotNull)
//⁃Id Karyawan (Yang melakukan Transaksi) (FK)
//⁃Id Usaha (FK)
//⁃Id Event (NullAble)
//⁃Time Stamp

struct Transaction {
    let id: Int
    let invoice: String
    let total: Double
    let cash: Double
    let change: Double
    let userId: String
    let shopId: String
    let timestamp: String
    let eventId: String
    var key: String
}

class TransactionModel {
    
    let transaction: Transaction!
    
    init?(dict: [String:Any]?) {
        var key: String = ""
        guard
            let dict = dict,
            let id = dict["id"] as? Int,
            let invoice = dict["invoice"] as? String,
            let total = dict["total"] as? Double,
            let change = dict["change"] as? Double,
            let cash = dict["cash"] as? Double,
            let shopId = dict["shopId"] as? String,
            let userId = dict["userId"] as? String,
            let timeStamp = dict["timeStamp"] as? String,
            let eventId = dict["eventId"] as? String
        else {return nil}
        if let value = dict["key"] as? String {
            key = value
        }
        transaction = Transaction(id: id, invoice: invoice, total: total, cash: cash, change: change, userId: userId, shopId: shopId, timestamp: timeStamp, eventId: eventId, key: key)
    }
    
}

//Item_Transaksi
//⁃Id Transaksi(PK, FK)
//⁃Id Item (FK)
//⁃Nama Item (String, NotNull)
//⁃Kuantiti item (Yang terjual) (Int, NotNull)
//⁃Harga Item (Satuan)(Int, NotNull)
//⁃Time Stamp

struct ItemTransaction: Hashable {
    let id: Int
    let itemName: String
    let itemCode: String
    let productId: String
    let price: Double
    let quantity: Int
    let timestamp: String
    let transactionId: String
}

class ItemTransactionModel {
    let item: ItemTransaction!
    
    init?(dict: [String:Any]?) {
        guard
            let dict = dict,
            let id = dict["id"] as? Int,
            let itemName = dict["itemName"] as? String,
            let itemCode = dict["itemCode"] as? String,
            let productId = dict["productId"] as? String,
            let price = dict["price"] as? Double,
            let timeStamp = dict["timestamp"] as? String,
            let quantity = dict["quantity"] as? Int,
            let transactionId = dict["transactionId"] as? String
        else {return nil}
        item = ItemTransaction(id: id, itemName: itemName, itemCode: itemCode, productId: productId, price: price, quantity: quantity, timestamp: timeStamp, transactionId: transactionId)
    }
}
