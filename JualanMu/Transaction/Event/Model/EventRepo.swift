//
//  EventRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 28/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

class EventRepo {
    
    private let onDefaultFailedResult = {
        return NSError(domain: "Gagal mendapatkan data", code: 100, userInfo: nil)
    }
    
    func createItems(event: Event? = nil) -> [EventItem] {
        guard let event = event else {return simpleItems()}
        var data: [EventItem] = []
        data.append(EventItem(title: "Nama Event", content: event.name))
        data.append(EventItem(title: "Tanggal Event Mulai", content: event.startDate))
        data.append(EventItem(title: "Tanggal Event Selesai", content: event.endDate))
        data.append(EventItem(title: "Lokasi Event", content: event.location))
        return data
    }
    
    func simpleItems() -> [EventItem] {
        var data: [EventItem] = []
        data.append(EventItem(title: "Nama Event", content: ""))
        data.append(EventItem(title: "Tanggal Event Mulai", content: ""))
        data.append(EventItem(title: "Tanggal Event Selesai", content: ""))
        data.append(EventItem(title: "Lokasi Event", content: ""))
        return data
    }
    
    func getEvents(onSuccess: (([Event])->Void)?, onFailed: DatabaseFailedCallback) {
        guard let uid = Preference.getString(forKey: .kUserUid) else {return onFailed!(NSError(domain: "Gagal mendapatkan data", code: 100, userInfo: nil))}
        var events: [Event] = []
        let model: EventFirebase =  EventFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: uid)
        firebase.getDataWithKey(onSuccess: { (data) in
            guard let data = data else {return onFailed!(self.onDefaultFailedResult())}
            data.forEach({ (snapshot) in
                if let item: EventModel = EventModel(dict: snapshot) {
                    events.append(item.event)
                } else {
                    onFailed?(self.onDefaultFailedResult())
                }
                onSuccess?(events)
            })
        
        }, onFailed: onFailed)
    }
    
    func submitEvent(event: Event, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        guard let uid = Preference.getString(forKey: .kUserUid) else {return onFailed!(NSError(domain: "Gagal mendapatkan data", code: 100, userInfo: nil))}
        let model: EventFirebase =  EventFirebase(event: event)
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: uid)
        firebase.postData(onSuccess: onSuccess, onFailed: onFailed)
    }
}
