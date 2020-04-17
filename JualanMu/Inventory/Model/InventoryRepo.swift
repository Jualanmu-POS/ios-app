//
//  InventoryRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 13/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

class InventoryRepo {
    
    func createItems(inventory: Inventory? = nil) -> [InventoryItem] {
        guard let inventory = inventory else {return simpleItems()}
        var data: [InventoryItem] = []
        data.append(InventoryItem(title: "", required: [], content: [""], item: [""]))
        data.append(InventoryItem(title: "DESKRIPSI PRODUK", required: [true,false,true], content: ["Nama Barang", "Kategori Barang", "Kode Barang"], item: [inventory.name, inventory.category , inventory.code]))
        data.append(InventoryItem(title: "HARGA PRODUK", required: [true,true,true], content: ["Ongkos", "Margin", "Harga"], item: ["\(inventory.cost.currencyFormat())", "\(inventory.margin) %", "\(inventory.price.currencyFormat())"]))
        data.append(InventoryItem(title: "STOK PRODUK", required: [false,false], content: ["Jumlah Stock", "Minimal Jumlah Stock"], item: ["\(inventory.currentStock)", "\(inventory.minimumStock)"]))
        return data
    }
    
    func simpleItems() -> [InventoryItem] {
        var data: [InventoryItem] = []
        data.append(InventoryItem(title: "", required: [], content: [""], item: [""]))
        data.append(InventoryItem(title: "DESKRIPSI PRODUK", required: [true,false,true], content: ["Nama Barang", "Kategori Barang", "Kode Barang"], item: ["", "" , ""]))
        data.append(InventoryItem(title: "HARGA PRODUK", required: [true,true,true], content: ["Ongkos", "Margin", "Harga"], item: ["", "", ""]))
        data.append(InventoryItem(title: "STOK PRODUK", required: [false,false], content: ["Jumlah Stock", "Minimal Jumlah Stock"], item: ["", ""]))
        return data
    }
    
    func saveToFirebase(inventory: Inventory, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: InventoryFirebase = InventoryFirebase(inventory: inventory)
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.postData(onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func updateInventory(key: String, inventory: Inventory, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: InventoryFirebase = InventoryFirebase(inventory: inventory)
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.updateValue(withKey: key, onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func retrieveData(onSuccess: (([Inventory])->Void)?, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        var results: [Inventory] = []
        let model: InventoryFirebase = InventoryFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.getDataWithKey(onSuccess: { (data) in
            guard let data = data else {return onFailed!(self.onDefaultFailedResult())}
            data.forEach({ (snapshot) in
                if let item: InventoryModel = InventoryModel(dict: snapshot) {
                    results.append(item.inventory)
                } else {
                    onFailed?(self.onDefaultFailedResult())
                }
            })
            onSuccess?(results)
        }, onFailed: onFailed)
    }
    
    func removeInventory(with key: String, onSuccess: DatabaseSuccessedCallback, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: InventoryFirebase = InventoryFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.deleteValue(withKey: key, onSuccess: onSuccess, onFailed: onFailed)
    }
    
    func getKeys(onSuccess: DatabaseKeySuccessedCallback, onFailed: DatabaseFailedCallback) {
        let isAnonymous: Bool = Preference.getBool(forKey: .kAnonymity) ?? true
        guard let uid = Preference.getString(forKey: .kUserUid), let token = Preference.getString(forKey: .kUserToken) else {return onFailed!(NSError(domain: "Aplikasi sedang terganggu. Coba lagi", code: 100, userInfo: nil))}
        let model: InventoryFirebase = InventoryFirebase()
        let firebase: FirebaseRetriever = FirebaseRetriever(blueprint: model, uid: isAnonymous ? token : uid)
        firebase.getKeys(onSuccess: { (keys) in
            guard let keys = keys else {return}
            onSuccess?(keys)
        }, onFailed: onFailed)
    }
    
    private let onDefaultFailedResult = {
        return NSError(domain: "Gagal mendapatkan data", code: 100, userInfo: nil)
    }
}
