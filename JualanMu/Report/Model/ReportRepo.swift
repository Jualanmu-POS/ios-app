//
//  ReportRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 25/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation


struct ProductReport: Hashable {
    let name: String
    let sku: String
    let price: Double
    var qty: Int
    let timestamp: String
    
    var total: Double {
        return price * Double(qty)
    }
}

struct ReportItem {
    let title: String
    let content: String
}

struct Report {
    var profit: Double
    var income: Double
    var outcome: Double
    var transactions: Int
}

class ReportRepo {
    
    private let transactionRepo: TransactionRepo!
    private let inventoryRepo: InventoryRepo!
    
    init(transactionRepo: TransactionRepo, inventoryRepo: InventoryRepo) {
        self.transactionRepo = transactionRepo
        self.inventoryRepo = inventoryRepo
    }
    
    private let onDefaultFailedResult = {
        return NSError(domain: "Gagal mendapatkan data", code: 100, userInfo: nil)
    }
    
    func createItems(report: Report? = nil) -> [ReportItem] {
        guard let report = report else {return createSimpleItems()}
        var items: [ReportItem] = []
        items.append(ReportItem(title: "Pemasukan", content: report.income.currencyFormat()))
        items.append(ReportItem(title: "Penjualan", content: "\(report.transactions) Transaksi"))
        items.append(ReportItem(title: "Laba", content: report.profit.currencyFormat()))
        items.append(ReportItem(title: "Top Event", content: "Belum Ada Data"))
        items.append(ReportItem(title: "Top Staff", content: "Belum Ada Data"))
        return items
    }
    
    private func createSimpleItems() -> [ReportItem] {
        var items: [ReportItem] = []
        items.append(ReportItem(title: "Pemasukan", content: "Belum Ada Data"))
        items.append(ReportItem(title: "Penjualan", content: "Belum Ada Data"))
        items.append(ReportItem(title: "Laba", content: "Belum Ada Data"))
        items.append(ReportItem(title: "Top Event", content: "Belum Ada Data"))
        items.append(ReportItem(title: "Top Staff", content: "Belum Ada Data"))
        return items
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
    
    func getTransactionsList(onSuccess: (([Transaction])->Void)?, onFailed: DatabaseFailedCallback) {
        transactionRepo.getTransactionList(onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func getProductsPerformance(isFiltered: Bool = true, onSuccess: (([ProductReport])->Void)?, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        var results: [ProductReport] = []
        let model: ItemTransactionFirebase = ItemTransactionFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.getData(onSuccess: { (data) in
            guard let data = data else {return onFailed!(self.onDefaultFailedResult())}
            data.forEach { (dict) in
                guard let item = ItemTransactionModel(dict: dict), let result = item.item else {return onFailed!(self.onDefaultFailedResult())}
                let productReport: ProductReport = ProductReport(name: result.itemName, sku: result.itemCode, price: result.price, qty: result.quantity, timestamp: result.timestamp)
                results.append(productReport)
            }
            if isFiltered {self.getResults(onSuccess: onSuccess, results)}
            else {onSuccess?(results)}
        }) { (err) in
            onFailed?(err)
        }
    }
    
    func getResults(onSuccess: (([ProductReport])->Void)?, _ results: [ProductReport]) {
        var data: [ProductReport] = []
        
        var set: Set<String> = []
        results.forEach { (productReport) in
            set.insert(productReport.sku)
        }
        
        var dict: [String:Int] = [:]
        set.forEach { (sku) in
            let data = results.filter({return $0.sku == sku}).map({$0.qty}).reduce(0, +)
            dict[sku] = data
        }
        
        dict.forEach { (value) in
            guard var product = results.filter({return $0.sku == value.key}).first else {return}
            product.qty = value.value
            data.append(product)
        }
        
        onSuccess?(data.sorted(by: { (x1, x2) -> Bool in
            return x1.qty > x2.qty
        }))
    }
}

extension ReportRepo {
    func buildReport(onComplete: ((Report)->Void)?, onFailed: DatabaseFailedCallback) {
        var report: Report = Report(profit: 0, income: 0, outcome: 0, transactions: 0)
        getTransactionsList(onSuccess: {
            report.transactions = $0.count
            self.getItemTransactions(onComplete: onComplete, report: report, onFailed: onFailed)
        }, onFailed: onFailed)
    }
    
    private func getItemTransactions(onComplete: ((Report)->Void)?, report: Report, onFailed: DatabaseFailedCallback) {
        var tempReport = report
        var itemTransactions: [ItemTransaction] = []
        getItemsTransaction(onSuccess: {
            $0.forEach { (item) in
                itemTransactions.append(item)
                let result = item.price * Double(item.quantity)
                tempReport.income += result
            }
            self.getProducts(onComplete: onComplete, report: tempReport, onFailed: onFailed, itemTransactions: itemTransactions)
        }, onFailed: onFailed)
    }
    
    private func getProducts(onComplete: ((Report)->Void)?, report: Report, onFailed: DatabaseFailedCallback, itemTransactions: [ItemTransaction]) {
        var tempReport = report
        getProduct(onSuccess: { (products) in
            itemTransactions.forEach { (item) in
                guard let product = products.filter({return $0.code == item.itemCode}).first else {return}
                let result = product.cost * Double(item.quantity)
                tempReport.outcome += result
            }
            tempReport.profit = tempReport.income - tempReport.outcome
            onComplete?(tempReport)
        }) { (err) in
            onFailed?(err)
        }
    }
    
    
}
