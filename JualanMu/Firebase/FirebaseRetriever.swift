//
//  FirebaseRetriever.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 14/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import FirebaseDatabase

typealias DatabaseSuccessedCallback = (([String:Any]?)->Void)?
typealias DatabaseSuccessedCallbackV2 = (([[String:Any]]?)->Void)?
typealias DatabaseSnapshotCallback = ((DataSnapshot)->Void)?
typealias DatabaseKeySuccessedCallback = (([String]?)->Void)?
typealias DatabaseFailedCallback = ((Error)->Void)?

enum Key: String {
    case inventory
    case transaction
    case item_transaction
    case event
    case base_url
    case owner
    case staf
    case user
}

class FirebaseRetriever {
    
    private let blueprint: FirebaseBlueprint
    private var ref: DatabaseReference!
    private let uid: String!
    
    init(blueprint: FirebaseBlueprint, uid: String) {
        self.blueprint = blueprint
        ref = Database.database().reference()
        self.uid = uid
    }
    
    func postData(isWithChild: Bool = true, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        if isWithChild {
            ref.child(blueprint.key().rawValue).child(uid).childByAutoId().setValue(blueprint.data()) { (error, ref) in
                if let error = error {
                  onFailed?(error)
                } else {
                  onSuccess?(nil)
                }
            }
        } else {
            ref.child(blueprint.key().rawValue).childByAutoId().setValue(blueprint.data()) { (error, ref) in
                if let error = error {
                  onFailed?(error)
                } else {
                  onSuccess?(nil)
                }
            }
        }
    }
    
    func getData(isWithChild: Bool = true, onSuccess: DatabaseSuccessedCallbackV2, onFailed: DatabaseFailedCallback) {
        var dicts: [[String:Any]] = []
        if isWithChild {
            ref.child(blueprint.key().rawValue).child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                if let _ = snapshot.value as? [String:Any] {
                    for child in snapshot.children {
                        guard let results = child as? DataSnapshot, let result = results.value as? [String:Any] else {return onFailed!(self.onDefaultFailedResult())}
                        dicts.append(result)
                    }
                    if dicts.count <= 0 {
                        onFailed?(NSError(domain: "Data Kosong", code: 101, userInfo: nil))
                    } else {onSuccess?(dicts)}
                } else {
                    onFailed?(self.onDefaultFailedResult())
                }
            }
        } else {
            ref.child(blueprint.key().rawValue).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                if let _ = snapshot.value as? [String:Any] {
                    for child in snapshot.children {
                        guard let results = child as? DataSnapshot, let result = results.value as? [String:Any] else {return onFailed!(self.onDefaultFailedResult())}
                        dicts.append(result)
                    }
                    if dicts.count <= 0 {
                        onFailed?(NSError(domain: "Data Kosong", code: 101, userInfo: nil))
                    } else {onSuccess?(dicts)}
                } else {
                    onFailed?(self.onDefaultFailedResult())
                }
            }
        }
        
    }
    
    func getDataWithKey(isWithChild: Bool = true, onSuccess: DatabaseSuccessedCallbackV2, onFailed: DatabaseFailedCallback) {
        var dicts: [[String:Any]] = []
        if isWithChild {
            ref.child(blueprint.key().rawValue).child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                if let results = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in results {
                        guard let value = child.value as? [String:Any] else {return onFailed!(self.onDefaultFailedResult())}
                        var dict: [String:Any] = value
                        dict["key"] = child.key
                        dicts.append(dict)
                    }
                    if dicts.count <= 0 {
                        onFailed?(NSError(domain: "Data Kosong", code: 101, userInfo: nil))
                    } else {onSuccess?(dicts)}
                } else {
                    onFailed?(self.onDefaultFailedResult())
                }
            }
        } else {
            ref.child(blueprint.key().rawValue).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                if let results = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in results {
                        guard let value = child.value as? [String:Any] else {return onFailed!(self.onDefaultFailedResult())}
                        var dict: [String:Any] = value
                        dict["key"] = child.key
                        dicts.append(dict)
                    }
                    if dicts.count <= 0 {
                        onFailed?(NSError(domain: "Data Kosong", code: 101, userInfo: nil))
                    } else {onSuccess?(dicts)}
                } else {
                    onFailed?(self.onDefaultFailedResult())
                }
            }
        }
        
    }
    
    func updateValue(isWithChild: Bool = true, withKey key: String, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        
        if isWithChild {
            ref.child(blueprint.key().rawValue).child(uid).child(key).setValue(blueprint.data()) { (error, ref) in
                if let error = error {
                  onFailed?(error)
                } else {
                  onSuccess?(nil)
                }
            }
        } else {
            ref.child(blueprint.key().rawValue).child(key).setValue(blueprint.data()) { (error, ref) in
                if let error = error {
                  onFailed?(error)
                } else {
                  onSuccess?(nil)
                }
            }
        }
        
        
    }
    
    func deleteValue(isWithChild: Bool = true, withKey key: String, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        if isWithChild {
            ref.child(blueprint.key().rawValue).child(uid).child(key).removeValue { (err, ref) in
                if let err = err {
                  onFailed?(err)
                } else {
                  onSuccess?(nil)
                }
            }
        } else {
            ref.child(blueprint.key().rawValue).child(key).removeValue { (err, ref) in
                if let err = err {
                  onFailed?(err)
                } else {
                  onSuccess?(nil)
                }
            }
        }
    }
    
    func getKeys(isWithChild: Bool = true, onSuccess: DatabaseKeySuccessedCallback, onFailed: DatabaseFailedCallback) {
        var keys: [String] = []
        ref.child(blueprint.key().rawValue).child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    keys.append(child.key)
                }
                onSuccess?(keys)
            } else {
                return onFailed!(self.onDefaultFailedResult())
            }
        }
    }
    
    func getBaseUrl() {
        ref.child(blueprint.key().rawValue).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let result = snapshot.value as? [String:Any], let url = result["base_url"] as? String {
                print("Result \(result)")
                Preference.set(value: url, forKey: .kBaseUrl)
            }
        }
    }
    
    private let onDefaultFailedResult = {
        return NSError(domain: "Gagal mendapatkan data", code: 100, userInfo: nil)
    }
}
