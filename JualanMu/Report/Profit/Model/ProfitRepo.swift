//
//  ProfitRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 27/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

struct ProfitHeader {
    var title: String
    var amount: Double
}

class ProfitRepo {
    
    private let reportRepo: ReportRepo!
    
    private let onDefaultFailedResult = {
        return NSError(domain: "Gagal mendapatkan data", code: 100, userInfo: nil)
    }
    
    init(reportRepo: ReportRepo) {
        self.reportRepo = reportRepo
    }
    
    func headerCell(title: String = "", amount: Double = 0.0) -> ProfitHeader {
        return ProfitHeader(title: title, amount: amount)
    }
    
    func getProductsPerformance(onSuccess: (([ProductReport])->Void)?, onFailed: DatabaseFailedCallback) {
        reportRepo.getProductsPerformance(onSuccess: onSuccess, onFailed: onFailed)
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
        reportRepo.getResults(onSuccess: onSuccess, results)
    }
}
