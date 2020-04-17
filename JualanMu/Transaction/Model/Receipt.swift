//
//  Receipt.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 18/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
struct Receipt {
    let products: [Product]
    let cashierName: String
    let total: String
    let change: String
    let cash: String
    let invoiceNumber: String
    let transactionDate: String
}
