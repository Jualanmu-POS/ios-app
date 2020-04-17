//
//  UserFirebase.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 10/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class UserFirebase: FirebaseBlueprint {
    
    private var user: User!
    
    init() {
        
    }
    
    convenience init(user: User) {
        self.init()
        self.user = user
    }
    
    func key() -> Key {
        return .user
    }
    
    func data() -> [String : Any] {
        return [
            "id":user.id,
            "shopName":user.shopName,
            "ownerName":user.name,
            "password":user.password,
            "timestamp":user.timestamp,
            "image":user.image,
            "token":user.token,
            "shopToken":user.shopToken,
            "isOwner":user.isOwner,
            "email":user.email
        ]
    }
    
    func childs(key: String) -> [String] {
        let child: String = Preference.getString(forKey: .kUserUid)!
        return [child]
    }
    
    
}
