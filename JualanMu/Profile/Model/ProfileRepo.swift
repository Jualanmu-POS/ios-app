//
//  ProfileRep.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 05/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

class ProfileRepo {
    
    private let auth: FirebaseAuthentication!
    private let userRepo: UserRepo!
    
    init(auth: FirebaseAuthentication, userRepo: UserRepo) {
        self.auth = auth
        self.userRepo = userRepo
    }
    
    func signIn(authentication: Authentication, onSuccess: ((User)->Void)?, onFailed: AuthCallbackFailed) {
        auth.signIn(withEmail: authentication.email, password: authentication.password, onSuccess: {
            self.getProfile(email: authentication.email, onSuccess: onSuccess, onFailed: onFailed)
        }, onFailed: onFailed)
    }
    
    func getProfile(email: String, onSuccess: ((User)->Void)?, onFailed: DatabaseFailedCallback) {
        userRepo.getProfile(withEmail: email, onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func registerShop(user: User, onSuccess: DatabaseSuccessedCallback, onAuthFailed: AuthCallbackFailed, onFailed: DatabaseFailedCallback) {
        auth.signUp(withEmail: user.email, password: user.password, onSuccess: {
            self.saveUser(user: user, onSuccess: onSuccess, onFailed: onFailed)
        }, onFailed: onAuthFailed)
    }
    
    func registerStaf(user: User, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        auth.signUp(withEmail: user.email, password: user.password, onSuccess: {
            self.userRepo.registerNewStaf(user: user, onSuccess: onSuccess, onFailed: onFailed)
        }) { (err) in
            onFailed?(err)
        }
    }
    
    func editProfile(user: User, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        self.userRepo.editProfile(user: user, onSuccess: onSuccess, onFailed: onFailed)
    }
    
    private func saveUser(user: User, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        userRepo.registerShop(withUser: user, onSuccess: onSuccess, onFailed: onFailed)
    }
    
//    func editProfile(user: User, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
//        auth.updateEmail(email: user.email, onSuccess: {
//            self.userRepo.editProfile(user: user, onSuccess: onSuccess, onFailed: onFailed)
//        }) { (err) in
//            onFailed?(err)
//        }
//    }
    
    func deleteStaf(user: User, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        userRepo.deleteStaf(user: user, onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func getStaf(onSuccess: (([User])->Void)?, onFailed: DatabaseFailedCallback) {
        userRepo.getStaf(onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func createProfileItems(user: User, numberOfStaff count: Int) -> [ProfileItem] {
        var items: [ProfileItem] = []
        if user.isOwner {
            items.append(ProfileItem(item: "Nama Usaha", content: user.shopName))
            items.append(ProfileItem(item: "Email Usaha", content: user.email))
            items.append(ProfileItem(item: "ID Usaha", content: String(user.shopToken.prefix(6))))
            items.append(emptyItem)
            items.append(emptyItem)
            items.append(ProfileItem(item: "Karyawan", content: "\(count)"))
            items.append(editItem)
            items.append(signOutItem)
        } else {
            items.append(ProfileItem(item: "Nama Usaha", content: user.shopName))
            items.append(ProfileItem(item: "ID Karyawan", content: String(user.token.prefix(6))))
            items.append(emptyItem)
            items.append(emptyItem)
            items.append(emptyItem)
            items.append(editItem)
            items.append(signOutItem)
        }
        
        return items
    }
    
    private var emptyItem: ProfileItem! {
        return ProfileItem(item: "", content: "")
    }
    
    private var editItem: ProfileItem! {
        return ProfileItem(item: "Ubah", content: "")
    }
    
    private var signOutItem: ProfileItem! {
        return ProfileItem(item: "Keluar", content: "")
    }
    
    func createEditProfileItems(user: User?, type: ProfileState) -> [ProfileItem] {
        guard let user = user else {return createDefaultEditProfileItems(type: type)}
        var items: [ProfileItem] = []
        if type == .editProfile {
            items.append(ProfileItem(item: "Nama Pengusaha", content: user.name))
            items.append(ProfileItem(item: "Email", content: user.email))
            if user.isOwner {items.append(ProfileItem(item: "Nama Usaha", content: user.shopName))}
        } else if type == .editStaff {
            items.append(ProfileItem(item: "Nama Karyawan", content: user.name))
            items.append(ProfileItem(item: "Email", content: user.email))
        }
        
        return items
    }
    
    private func createDefaultEditProfileItems(type: ProfileState) -> [ProfileItem] {
        var items: [ProfileItem] = []
        if type == .editProfile {
            items.append(ProfileItem(item: "Nama Pengusaha", content: ""))
            items.append(ProfileItem(item: "Email", content: ""))
            items.append(ProfileItem(item: "Nama Usaha", content: ""))
        } else if type == .addStaff {
            items.append(ProfileItem(item: "Nama Karyawan", content: ""))
            items.append(ProfileItem(item: "Email", content: ""))
        }
        return items
    }
}
