//
//  Event.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 28/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

struct EventItem {
    let title: String
    var content: String
}

struct Event {
    let name: String
    let startDate: String
    let endDate: String
    let location: String
    let timestamp: String
    let shopId: String
    let key: String
}

class EventModel {
    
    let event: Event!
    
    init?(dict: [String:Any]?) {
        guard let dict = dict,
            let name = dict["name"] as? String,
            let startDate = dict["startDate"] as? String,
            let endDate = dict["endDate"] as? String,
            let location = dict["location"] as? String,
            let timestamp = dict["timestamp"] as? String,
            let shopId = dict["shopId"] as? String,
            let key = dict["key"] as? String
            else {return nil}
        
        event = Event(name: name, startDate: startDate, endDate: endDate, location: location, timestamp: timestamp, shopId: shopId, key: key)
    }
}
