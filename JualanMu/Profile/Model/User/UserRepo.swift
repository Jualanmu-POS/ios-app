//
//  UserRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 10/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
class UserRepo {
    
    func registerShop(withUser user: User, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: UserFirebase = UserFirebase(user: user)
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.postData(isWithChild: false, onSuccess: { (value) in
            Preference.set(value: true, forKey: .kIsOwner)
            onSuccess?(value)
        }, onFailed: onFailed)
    }
    
    func getProfile(withEmail email: String, onSuccess: ((User)->Void)?, onFailed: DatabaseFailedCallback) {
        let model: UserFirebase = UserFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: "")
        var users: [User] = []
        firebase.getDataWithKey(isWithChild: false, onSuccess: { (results) in
            guard let results = results else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
            results.forEach { (dict) in
                guard let model = UserModel(dict: dict) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
                users.append(model.user)
            }
            guard let user = users.filter({return $0.email == email}).first else {return onFailed!(NSError(domain: "Pengguna tidak ditemukan", code: 100, userInfo: nil))}
            onSuccess?(user)
        }, onFailed: onFailed)
    }
    
    func getStaf(onSuccess: (([User])->Void)?, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: UserFirebase = UserFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        var users: [User] = []
        firebase.getDataWithKey(isWithChild: false, onSuccess: { (results) in
            guard let results = results else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
            results.forEach { (dict) in
                guard let model = UserModel(dict: dict) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
                users.append(model.user)
            }
            onSuccess?(users)
        }, onFailed: onFailed)
    }
    
    func registerNewStaf(user: User, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: UserFirebase = UserFirebase(user: user)
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.postData(isWithChild: false, onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func editProfile(user: User, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: UserFirebase = UserFirebase(user: user)
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.updateValue(isWithChild: false, withKey: user.key, onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func deleteStaf(user: User, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: UserFirebase = UserFirebase(user: user)
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.deleteValue(isWithChild: false, withKey: user.key, onSuccess: onSuccess, onFailed: onFailed)
    }
}
