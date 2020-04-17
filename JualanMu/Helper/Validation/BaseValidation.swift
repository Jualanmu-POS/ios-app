//
//  BaseValidation.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 28/10/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

enum Regex: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case alphabet = ".*[^A-Za-z ].*"
    case numeric = "^[0-9]{1,}$"
    case date = "dd MMMM yyyy"
    case alphanumeric = ".*[a-zA-Z0-9 ].*"
}

class BaseValidation: Validation {
    
    func check(s: String, regex: Regex) -> Bool {
        if regex == .alphabet {
            do {
                let expression = try NSRegularExpression(pattern: regex.rawValue, options: [])
                return expression.firstMatch(in: s, options: [], range: NSMakeRange(0, s.count)) == nil
            } catch {
                return false
            }
        } else {
            let predicate = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
            return predicate.evaluate(with: s)
        }
    }
    
    func isDateValid(s: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Regex.date.rawValue
        return dateFormatter.date(from: s) != nil
    }
    
    func isEmpty(s: String) -> Bool {
        return s.isEmpty()
    }
}
