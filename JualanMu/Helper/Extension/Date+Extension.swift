//
//  Date+Extension.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 15/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

enum Format: String {
    case dayWithMinutes = "dd/MM/yyyy HH:mm:ss"
    case dayWithStrip = "dd/MM/yyyy"
    case dayNormal = "dd MMM yyyy"
    case dayShortDetail = "EEE, d MMM yyyy"
    case dayDetail = "EEEE, d MMMM yyyy"
    case monthYearOnly = "MMMM yyyy"
}

extension Date {
    func formatDate(format: Format = .dayWithStrip) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    func addingDate(add: Int) -> [String]? {
        var results: [String] = []
        for i in 0..<add {
            var dayComponent: DateComponents = DateComponents()
            dayComponent.day = -i
            let cal = Calendar.current
            guard let addedDate = cal.date(byAdding: dayComponent, to: self) else {return nil}
            results.append(addedDate.formatDate(format: .dayWithStrip))
        }
        return results
    }
    
    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
            Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    func getAllDays() -> [String]? {
        var results: [String] = []
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        for i in 0..<range.count {
            var dayComponent: DateComponents = DateComponents()
            dayComponent.day = i
            guard let addedDate = calendar.date(byAdding: dayComponent, to: self) else {return nil}
            results.append(addedDate.formatDate(format: .dayWithStrip))
        }

        return results.reversed()
    }
    
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    func epochTime() -> String {
        let date = Date().timeIntervalSince1970
        let value = String(date)
        return value.contains(".") ? value.replacingOccurrences(of: ".", with: "") : value
    }
    
    func dateAt(hours: Int, minutes: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)

        //get the month/day/year componentsfor today's date.
        var dateComponents = calendar.dateComponents([
            .year,
            .month,
            .day
        ], from: self)

        //Create an NSDate for the specified time today.
        dateComponents.hour = hours
        dateComponents.minute = minutes
        dateComponents.second = 0
        
        let newDate = calendar.date(from: dateComponents)!
        return newDate
    }
    
//    let now = Date()
//    let eight_today = now.dateAt(hours: 8, minutes: 0)
//    let four_thirty_today = now.dateAt(hours: 16, minutes: 30)
//
//    if now >= eight_today &&
//      now <= four_thirty_today
//    {
//      print("The time is between 8:00 and 16:30")
//    }
}
