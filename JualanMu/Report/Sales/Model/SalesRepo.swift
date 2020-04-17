//
//  SalesRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 29/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
struct SalesHeader {
    var title: String
    var amount: Int
}

class SalesRepo {
    
    private let reportRepo: ReportRepo!
    
    private let onDefaultFailedResult = {
        return NSError(domain: "Gagal mendapatkan data", code: 100, userInfo: nil)
    }
    
    init(reportRepo: ReportRepo) {
        self.reportRepo = reportRepo
    }
    
    func headerCell(title: String = "", amount: Int = 0) -> SalesHeader {
        return SalesHeader(title: title, amount: amount)
    }
    
    func getProductsPerformance(onSuccess: (([ProductReport])->Void)?, onFailed: DatabaseFailedCallback) {
        reportRepo.getProductsPerformance(onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func getTransactions(date: [String], onSuccess: (([Transaction])->Void)?, onFailed: DatabaseFailedCallback) {
        var data:[Transaction] = []
        reportRepo.getTransactionsList(onSuccess: { (results) in
            date.forEach { (timestamp) in
                let tempData = results.filter({return $0.timestamp.split(separator: " ").first! == timestamp})
                tempData.forEach({data.append($0)})
            }
            onSuccess?(data)
        }, onFailed: onFailed)
    }
    
    func getPerformances(date: [String], onSuccess: (([ProductReport])->Void)?, onFailed: DatabaseFailedCallback) {
        reportRepo.getProductsPerformance(isFiltered: false, onSuccess: { (results) in
            self.filterData(date: date, data: results, onSuccess: onSuccess)
        }, onFailed: onFailed)
    }
    
    private func filterData(date: [String], data: [ProductReport], onSuccess: (([ProductReport])->Void)?) {
        var results: [ProductReport] = []
        date.forEach { (timestamp) in
            let tempData = data.filter({return $0.timestamp.split(separator: " ").first! == timestamp})
            tempData.forEach({results.append($0)})
        }
        self.reportRepo.getResults(onSuccess: onSuccess, results)
    }
    
}
