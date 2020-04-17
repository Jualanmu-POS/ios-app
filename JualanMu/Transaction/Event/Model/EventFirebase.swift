//
//  EventFirebase.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 28/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

class EventFirebase: FirebaseBlueprint {
    
    private var event: Event!
    
    init() {
        
    }
    
    convenience init(event: Event) {
        self.init()
        self.event = event
    }
    
    func key() -> Key {
        return .event
    }
    
    func data() -> [String : Any] {
        return [
            "name":event.name,
            "startDate":event.startDate,
            "endDate":event.endDate,
            "location":event.location,
            "timestamp":event.timestamp,
            "shopId":event.shopId
        ]
    }
    
    func childs(key: String) -> [String] {
        let uid: String = Preference.getString(forKey: .kUserUid)!
        return [uid]
    }
    
    
}
