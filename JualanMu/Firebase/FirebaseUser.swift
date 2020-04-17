//
//  FirebaseUser.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 14/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import FirebaseAuth
class FirebaseUser {
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    func saveCurrentUser() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {return}
            print("User UID \(user.uid)")
            if user.isAnonymous {
                Preference.set(value: user.uid, forKey: .kUserUid)
                Preference.set(value: user.uid, forKey: .kUserToken)
            }
        }
    }
    
    func removeListener() {
        guard let handle = handle else {return}
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    func setUserAnonymity() {
        let auth = FirebaseAuthentication(validation: BaseValidation())
        Preference.set(value: auth.isAnonymous(), forKey: .kAnonymity) 
    }
}
