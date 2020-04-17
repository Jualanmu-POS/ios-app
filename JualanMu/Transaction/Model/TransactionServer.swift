//
//  TransactionServer.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 02/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
import Alamofire

class TransactionServer {
    private let route: String = "/mail"
    
    func sendEmail(receipt: Receipt, email: String, name: String) {
        guard let baseUrl = Preference.getString(forKey: .kBaseUrl) else {return}
        var items: [[String:Any]] = []
        let timestamp = receipt.transactionDate.split(separator: " ")
        let date = String(timestamp[0]); let time = String(timestamp[1])
        let mailUrl: String = baseUrl + route
        receipt.products.forEach({
            let total: Double = Double($0.quantity) * $0.price
            items.append([
                "item":$0.name,
                "harga":total,
                "qty":$0.quantity
            ])
        })
        let content: [String:Any] = [
            "invoice": receipt.invoiceNumber,
            "tanggal": date,
            "waktu": time,
            "kasir": name,
            "total": receipt.total.removeCurrency(),
            "cash": receipt.cash.removeCurrency()
        ]
        let params: [String:Any] = [
            "email":email,
            "receipt":content,
            "items":items
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        Alamofire.request(mailUrl, method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: headers).responseJSON {
            response in
            
        }
    }
}
