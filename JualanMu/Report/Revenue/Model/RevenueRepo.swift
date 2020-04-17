//
//  RevenueRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 27/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

struct RevenueHeader {
    var title: String
    var amount: Double
}

class RevenueRepo {
    
    private let inventoryRepo: InventoryRepo
    private let transactionRepo: TransactionRepo
    
    private let onDefaultFailedResult = {
        return NSError(domain: "Gagal mendapatkan data", code: 100, userInfo: nil)
    }
    
    init(inventoryRepo: InventoryRepo, transactionRepo: TransactionRepo) {
        self.inventoryRepo = inventoryRepo
        self.transactionRepo = transactionRepo
    }
    
    func headerCell(title: String = "", amount: Double = 0.0) -> RevenueHeader {
        return RevenueHeader(title: title, amount: amount)
    }
    
    func getTransactions(date: String, onGetRevenue: ((Revenue)->Void)?, onFailed: DatabaseFailedCallback){
        transactionRepo.getTransactionList(onSuccess: { (results) in
            let tempData = results.filter { return $0.timestamp.split(separator: " ").first ?? "" == date }
            let revenue: Revenue = Revenue(date: date, transactions: tempData)
            onGetRevenue?(revenue)
        }, onFailed: onFailed)
    }
    
    func getTransactionIds(onSuccess: (([String])->Void)?, onFailed: DatabaseFailedCallback) {
        transactionRepo.getTransactionIds(onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func getItemTransactions(with key: String, onSuccess: (([ItemTransaction])->Void)?, onFailed: DatabaseFailedCallback) {
        transactionRepo.getItemTransactions(with: key, onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func getItemsTransaction(onSuccess: (([ItemTransaction])->Void)?, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        var itemTransactions: [ItemTransaction] = []
        let model: ItemTransactionFirebase = ItemTransactionFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.getData(onSuccess: { (data) in
            guard let data = data else {return onFailed!(self.onDefaultFailedResult())}
            data.forEach({ (dict) in
                if let item = ItemTransactionModel(dict: dict) {
                    itemTransactions.append(item.item)
                }
            })
            onSuccess?(itemTransactions)
        }, onFailed: onFailed)
    }
    
    func getProduct(onSuccess: (([Inventory])->Void)?, onFailed: DatabaseFailedCallback) {
        inventoryRepo.retrieveData(onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func getRevenue(total: Double, date: String, onSuccess: ((Double)->Void)?, onFailed: DatabaseFailedCallback) {
        var revenue: Double = 0.0
        getItemsTransaction(onSuccess: { (itemTransactions) in
            self.getProduct(onSuccess: { (products) in
                let filteredItemTransactions = itemTransactions.filter({
                    return $0.timestamp.split(separator: " ")[0] == date
                })
                if filteredItemTransactions.count > 0 {
                    filteredItemTransactions.forEach { (item) in
                        guard let product = products.filter({return $0.code == item.itemCode}).first else {return}
                        let result = product.cost * Double(item.quantity)
                        revenue += result
                    }
                }
                onSuccess?(total - revenue)
            }) { (err) in
                onFailed?(err)
            }
        }, onFailed: onFailed)
    }
    
    func getCashier(withId id: String, onSuccess: ((String)->Void)?, onFailed: DatabaseFailedCallback) {
        let repo: UserRepo = UserRepo()
        repo.getStaf(onSuccess: { (results) in
            guard let profile = results.filter({return $0.token == id}).first else {return}
            onSuccess?(profile.name)
        }, onFailed: onFailed)
    }
}
