//
//  Preference.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 15/10/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

enum PreferenceKey: String {
    case kOnBoarding
    case kLoggedIn
    case kUserToken
    case kUserUid
    case kBaseUrl
    case kAnonymity
    case kIsOwner
    case kShopname
    case kUsername
    case kUserEmail
    case kHasLoggedIn
}

struct Preference {
    
    static func set(value: Any?, forKey key: PreferenceKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func getString(forKey key: PreferenceKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    static func getInt(forKey key: PreferenceKey) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    static func getBool(forKey key: PreferenceKey) -> Bool? {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func isFirstimeLaunch() -> Bool? {
        return getBool(forKey: .kOnBoarding)
    }
    
    static func hasLoggedIn() -> Bool {
        return getBool(forKey: .kLoggedIn) ?? false
    }
    
    static func saveProfile(user: User) {
        Preference.set(value: false, forKey: .kAnonymity)
        Preference.set(value: user.email, forKey: .kUserEmail)
        Preference.set(value: user.shopToken, forKey: .kUserUid)
        Preference.set(value: user.token, forKey: .kUserToken)
        Preference.set(value: user.isOwner, forKey: .kIsOwner)
        Preference.set(value: user.name, forKey: .kUsername)
        Preference.set(value: user.shopName, forKey: .kShopname)
    }
}
