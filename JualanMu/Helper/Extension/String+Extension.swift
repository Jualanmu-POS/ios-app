//
//  String+Extension.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 14/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

enum Currency: String {
    case rupiah = "Rp"
}

extension String {
    
    func isEmpty() -> Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines) == "" || isEmpty
    }
    
    func currencyInputFormatting(withSpacing: Bool = true, type: Currency = .rupiah) -> String {
        let currency = withSpacing ? "\(type.rawValue) " : type.rawValue
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]{0,17}", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
    
    func removeCurrency(withSpacing: Bool = true, type: Currency = .rupiah) -> Double {
        let currency = withSpacing ? "\(type.rawValue) " : type.rawValue
        if !contains(currency) {
            return Double(self) ?? 0.0
        } else {
            let format = NumberFormatter()
            format.numberStyle = NumberFormatter.Style.currency
            format.currencySymbol = currency
            format.decimalSeparator = contains(",") ? "," : "."
            let number: Double = Double(truncating: format.number(from: self) ?? 0.0)
            return number
        }
        
    }
    
    func getAppropriateDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let dateObj = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: dateObj)
    }
    
    var asDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.date(from: self) ?? Date()
    }

}

extension Int {
    func currencyFormat(type: Currency = .rupiah, withSpacing: Bool = true) -> String {
        let format = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        let numberFormat = format.string(from: NSNumber(value: self))!
        if withSpacing {
            return "\(type.rawValue) \(numberFormat)"
        }
        return "\(type.rawValue)\(numberFormat)"
    }
}

extension Double {
    func currencyFormat(type: Currency = .rupiah, minFractionDigits: Int = 1, maxFractionDigits: Int = 2, withSpacing: Bool = true) -> String {
        let format = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.minimumFractionDigits = minFractionDigits
        format.maximumFractionDigits = maxFractionDigits
        let numberFormat = format.string(from: NSNumber(value: self))!
        if withSpacing {
            return "\(type.rawValue) \(numberFormat)"
        }
        return "\(type.rawValue)\(numberFormat)"
    }
}
