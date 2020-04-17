//
//  User.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 10/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
struct User {
    let id: Int
    let shopName: String
    let name: String
    let email: String
    let password: String
    let token: String
    let shopToken: String
    let image: String
    let isOwner: Bool
    let timestamp: String
    var key: String
}

class UserModel {
    let user: User!
    
    init?(dict: [String:Any]?) {
        var key: String = ""
        guard
            let dict = dict,
            let id = dict["id"] as? Int,
            let shopName = dict["shopName"] as? String,
            let ownerName = dict["ownerName"] as? String,
            let email = dict["email"] as? String,
            let password = dict["password"] as? String,
            let token = dict["token"] as? String,
            let shopToken = dict["shopToken"] as? String,
            let image = dict["image"] as? String,
            let isOwner = dict["isOwner"] as? Bool,
            let timestamp = dict["timestamp"] as? String
        else {return nil}
        if let value = dict["key"] as? String {
            key = value
        }
        
        user = User(id: id, shopName: shopName, name: ownerName, email: email, password: password, token: token, shopToken: shopToken, image: image, isOwner: isOwner, timestamp: timestamp, key: key)
    }
        
}
