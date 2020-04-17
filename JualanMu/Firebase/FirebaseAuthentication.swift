//
//  FirebaseAuth.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 14/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import FirebaseAuth

typealias AuthCallbackSuccessed = (()->Void)?
typealias AuthCallbackFailed = ((Error)->Void)?

class FirebaseAuthentication {
    
    private let validation: Validation!
    
    init(validation: Validation) {
        self.validation = validation
    }
    
    func deleteCurrentUser() {
        Auth.auth().currentUser?.delete(completion: nil)
    }
    
    func signInAnonymously(onSuccess: AuthCallbackSuccessed, onFailed: AuthCallbackFailed) {
        Auth.auth().signInAnonymously { (result, err) in
            if let err = err {
                onFailed?(err)
            } else {
                onSuccess?()
            }
        }
    }
    
    func isAnonymous() -> Bool {
        guard let currentUser = Auth.auth().currentUser else {return true}
        return currentUser.isAnonymous
    }
    
    func signIn(withEmail email: String, password: String, onSuccess: AuthCallbackSuccessed, onFailed: AuthCallbackFailed) {
         if !verify(email: email) {
             let err = NSError(domain: "Email yang dimasukan tidak valid", code: 100, userInfo: nil)
             onFailed?(err)
         } else {
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                if let err = err {
                    onFailed?(err)
                } else {
                    onSuccess?()
                }
            }
        }
    }
    
    func signUp(withEmail email: String, password: String, onSuccess: AuthCallbackSuccessed, onFailed: AuthCallbackFailed) {
        if !verify(email: email) {
            let err = NSError(domain: "Email yang dimasukan tidak valid", code: 100, userInfo: nil)
            onFailed?(err)
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if let err = err {
                    onFailed?(err)
                } else {
                    onSuccess?()
                }
            }
        }
    }
    
    func signOut(onSuccess: (()->Void)?, onFailure: ((NSError)->Void)?) {
        do {
            try Auth.auth().signOut()
            onSuccess?()
        } catch {
            onFailure?(NSError(domain: "Gagal keluar dari aplikasi. Coba lagi", code: 101, userInfo: nil))
        }
    }
    
    func updateEmail(email: String, onSuccess: (()->Void)?, onFailure: ((Error)->Void)?) {
        guard let currentUser = Auth.auth().currentUser else {return}
        currentUser.updateEmail(to: email) { (err) in
            if let err = err {
                onFailure?(err)
            } else {
                onSuccess?()
            }
        }
    }
    
    private func verify(email: String) -> Bool {
        let isValid: Bool = validation.check(s: email, regex: .email)
        return isValid
    }
}
