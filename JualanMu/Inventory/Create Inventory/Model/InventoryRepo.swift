//
//  InventoryRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 08/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
class InventoryRepo {

    func createInventoryContent() -> [InventoryContent] {
        var data: [InventoryContent] = []
        data.append(InventoryContent(title: "", items: [""]))
        data.append(InventoryContent(title: "DESKRIPSI PRODUK", items: ["Nama Barang", "Kategori Barang" , "Kode Barang"]))
        data.append(InventoryContent(title: "HARGA PRODUK", items: ["Ongkos", "Margin", "Harga"]))
        data.append(InventoryContent(title: "STOK PRODUK", items: ["Jumlah Stock", "Minimal Jumlah Stock"]))
        return data
    }
}
