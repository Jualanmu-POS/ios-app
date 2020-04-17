//
//  TransactionRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 15/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

class TransactionRepo {
    
    func getTransactionWithKey() {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else { return }
        let model: InventoryFirebase = InventoryFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.getDataWithKey(onSuccess: { (results) in
            guard let results = results else {return}
            results.forEach { (dict) in
                print("Data dengan unique ID \(dict)")
            }
        }) { (err) in
            print(err)
        }
    }
    
    func getCashier(withId id: String, onSuccess: ((String)->Void)?, onFailed: DatabaseFailedCallback) {
        let repo: UserRepo = UserRepo()
        repo.getStaf(onSuccess: { (results) in
            let profile = results.filter({return $0.token == id}).first
            let uid: String = Preference.getString(forKey: .kUsername) ?? "Guest"
            onSuccess?(profile?.name ?? uid)
        }, onFailed: onFailed)
    }
    
    func getProductList(onSuccess: (([Product])->Void)?, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        var products: [Product] = []
        let model: InventoryFirebase = InventoryFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.getDataWithKey(onSuccess: { (results) in
            guard let results = results else {return onFailed!(self.onDefaultFailedResult())}
            results.forEach { (dict) in
                if let item: InventoryModel = InventoryModel(dict: dict), let data = item.inventory {
                    let product = Product(id: data.id, name: data.name, image: data.image, category: data.category, code: data.code, cost: data.cost, margin: data.margin, price: data.price, currentStock: data.currentStock, minimumStock: data.minimumStock, shopId: data.shopId, userId: data.userId, timeStamp: data.timeStamp, quantity: 1, productId: data.key, isSelected: false)
                    products.append(product)
                } else {
                    onFailed?(self.onDefaultFailedResult())
                }
            }
            onSuccess?(products)
        }, onFailed: onFailed)
    }
    
    func addItemTransaction(itemTransaction: ItemTransaction, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: ItemTransactionFirebase = ItemTransactionFirebase(itemTransaction: itemTransaction)
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.postData(onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func getTransactionList(eventId: String = "", onSuccess: (([Transaction])->Void)?, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        var results: [Transaction] = []
        let model: TransactionFirebase = TransactionFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.getDataWithKey(onSuccess: { (data) in
            guard let data = data else {return onFailed!(self.onDefaultFailedResult())}
            data.forEach { (snapshot) in
                if let item: TransactionModel = TransactionModel(dict: snapshot) {
                    results.append(item.transaction)
                } else {
                    onFailed?(self.onDefaultFailedResult())
                }
            }
            if eventId.elementsEqual("") {onSuccess?(results)}
            else {
                let eventResults = results.filter({return $0.eventId == eventId})
                onSuccess?(eventResults)
            }
        }, onFailed: onFailed)
        
    }
    
    func getTransactionIds(onSuccess: (([String])->Void)?, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: TransactionFirebase = TransactionFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.getKeys(onSuccess: { (keys) in
            guard let keys = keys else {return onFailed!(self.onDefaultFailedResult())}
            onSuccess?(keys)
        }, onFailed: onFailed)
    }
    
    func getItemTransactions(with key: String, onSuccess: (([ItemTransaction])->Void)?, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        var itemTransactions: [ItemTransaction] = []
        let model: ItemTransactionFirebase = ItemTransactionFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.getDataWithKey(onSuccess: { (data) in
            guard let data = data else {return onFailed!(self.onDefaultFailedResult())}
            data.forEach({ (dict) in
                if let item = ItemTransactionModel(dict: dict) {
                    itemTransactions.append(item.item)
                }
            })
            onSuccess?(itemTransactions)
        }) { (err) in
            onFailed?(err)
        }
    }
    
    func getLastTransactionId(onSuccess: ((String)->Void)?, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: TransactionFirebase = TransactionFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.getKeys(onSuccess: { (keys) in
            guard let keys = keys, let key = keys.last else {return onFailed!(self.onDefaultFailedResult())}
            onSuccess?(key)
        }, onFailed: onFailed)
    }
    
    func createTransaction(transaction: Transaction, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: TransactionFirebase = TransactionFirebase(transaction: transaction)
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.postData(onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func sendReceipt(receipt: Receipt, email: String, name: String) {
        let server: TransactionServer = TransactionServer()
        server.sendEmail(receipt: receipt, email: email, name: name)
    }
    
    private let onDefaultFailedResult = {
        return NSError(domain: "Gagal mendapatkan data", code: 100, userInfo: nil)
    }
}
