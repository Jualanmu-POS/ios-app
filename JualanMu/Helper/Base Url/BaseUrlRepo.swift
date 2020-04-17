//
//  BaseUrlRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 02/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
class BaseUrlRepo {
    
    func getBaseUrl() {
        guard let uid = Preference.getString(forKey: .kUserUid) else {return}
        let model: BaseUrlFirebase = BaseUrlFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: uid)
        firebase.getBaseUrl()
//        firebase.getData(onSuccess: { (results) in
//            guard let results = results, let baseUrl = results.first?["base_url"] as? String else {return}
//            Preference.set(value: baseUrl, forKey: .kBaseUrl)
//        }, onFailed: nil)
    }
    
}
