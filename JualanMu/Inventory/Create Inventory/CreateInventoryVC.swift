//
//  CreateInventoryVC.swift
//  JualanMu
//
//  Created by Hendy Sen on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseUI
import ProgressHUD

class CreateInventoryVC: UIViewController {
    
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var isEditingMode = false
    var inventory: Inventory? = nil
    var repo: InventoryRepo = InventoryRepo()
    var imageRepo: ImageStorageRepo = ImageStorageRepo()
    var item: [InventoryItem] = []
    var imagePicker: ImagePicker!
    var imageData: Data!
    var tempImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHideKeyboard()
        addAndEdit()
        setupNavBar()
        item = repo.createItems(inventory: inventory)
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavBar() {
        navigationItem.title = isEditingMode ? "Ubah Produk" : "Tambah Produk"
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.backBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupTableView() {
        let nibPhoto = UINib.init(nibName: "PhotoTableViewCell", bundle: nil)
        tableView.register(nibPhoto, forCellReuseIdentifier: "PhotoTableViewCell")
        
        let nibDeskripsi = UINib.init(nibName: "DeskripsiProdukTableViewCell", bundle: nil)
        tableView.register(nibDeskripsi, forCellReuseIdentifier: "DeskripsiProdukTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func addAndEdit() {
        if isEditingMode {
            navigationItem.rightBarButtonItem = .init(title: "Ubah", style: .done, target: self, action: #selector(editItem))
        } else {
            navigationItem.rightBarButtonItem = .init(title: "Tambah", style: .done, target: self, action: #selector(addItem))
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func addItem() {
        guard let uid: String = Preference.getString(forKey: .kUserUid) else {return}
        let cost = item[2].item[0].removeCurrency()
        let margin = Double(item[2].item[1].replacingOccurrences(of: " %", with: "")) ?? -1
        let price = item[2].item[2].removeCurrency()
        var image: String = ""
        
        if let _ = imageData {
            image = "\(uid)/images/inventory/\(item[1].item[0]).png"
        }
        
        let inventory = Inventory(
            id: 0,
            name: item[1].item[0],
            image: image,
            category: item[1].item[1],
            code: item[1].item[2],
            cost: cost,
            margin: margin,
            price: price,
            currentStock: Int(item[3].item[0]) ?? 0,
            minimumStock: Int(item[3].item[1]) ?? 0,
            shopId: uid,
            userId: uid,
            timeStamp: Date().formatDate(format: .dayWithMinutes),
            key: ""
        )
        
        if validateItems(inventory) {
            if let imageData = imageData {
                startLoading(message: "Menambah produk")
                imageRepo.uploadNewImage(imagePath: inventory.image, imageData: imageData, completion: {
                    self.addRepoItem(inventory)
                })
            } else {
                startLoading(message: "Menambah produk")
                addRepoItem(inventory)
            }
        }
    }
    
    @objc func editItem() {
        guard let uid: String = Preference.getString(forKey: .kUserUid), let token: String = Preference.getString(forKey: .kUserToken), let inventory = inventory else {return}
        let cost = item[2].item[0].removeCurrency()
        let margin = Double(item[2].item[1].replacingOccurrences(of: " %", with: "")) ?? -1
        let price = item[2].item[2].removeCurrency()
        var image: String = inventory.image
        
        if let _ = imageData {
            image = "\(uid)/images/inventory/\(item[1].item[0]).png"
        }
        
        let newInventory = Inventory(
            id: inventory.id,
            name: item[1].item[0],
            image: image,
            category: item[1].item[1],
            code: item[1].item[2],
            cost: cost,
            margin: margin,
            price: price,
            currentStock: Int(item[3].item[0])!,
            minimumStock: Int(item[3].item[1])!,
            shopId: uid,
            userId: token,
            timeStamp: Date().formatDate(format: .dayWithMinutes),
            key: inventory.key
        )
        
        if validateItems(newInventory) {
            
            if inventory.name != newInventory.name {
                if inventory.image != "" {
                    imageData = UIImage.pngData(tempImage)()
                }
            }
            
            if let imageData = imageData {
                startLoading(message: "Mengubah produk")
                imageRepo.updateImage(oldPath: inventory.image, newPath: newInventory.image, imageData: imageData, completion: {
                    self.editRepoItem(inventory.key, newInventory)
                })
            } else {
                startLoading(message: "Mengubah produk")
                editRepoItem(inventory.key, newInventory)
            }
        }
    }
    
    func addRepoItem(_ inventory: Inventory) {
        self.repo.saveToFirebase(inventory: inventory, onSuccess: { [weak self] (snapshot) in
            guard let self = self else {return}
            self.finishLoading(message: "Produk berhasil ditambah!", showSuccess: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
            }
        }) { [weak self] (err) in
            guard let self = self else {return}
            self.showError(err.localizedDescription)
            ProgressHUD.showError(err.localizedDescription)
        }
    }
    
    func editRepoItem(_ inventoryKey: String,_ newInventory: Inventory){
        self.repo.updateInventory(key: inventoryKey, inventory: newInventory, onSuccess: { [weak self] (_) in
            guard let self = self else {return}
            self.finishLoading(message: "Produk berhasil diubah!", showSuccess: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.navigationController?.popViewController(animated: true)
            }
        }) { [weak self] (err) in
            guard let self = self else {return}
            self.showError(err.localizedDescription)
            ProgressHUD.showError(err.localizedDescription)
        }
    }
    
    func validateItems(_ inventory: Inventory) -> Bool{
        let validator = BaseValidation()
        
        if !validator.check(s: inventory.name, regex: .alphanumeric){
            showError("Nama barang yang anda masukan tidak valid.")
            finishLoading()
            return false
        }
        
        if !validator.check(s: inventory.code, regex: .alphanumeric){
            showError("Kode barang yang anda masukan tidak valid.")
            finishLoading()
            return false
        }
        
        if !validator.check(s: String(format: "%.0f", inventory.cost), regex: .numeric) || inventory.cost <= 0 {
            showError("Ongkos yang anda masukan tidak valid.")
            finishLoading()
            return false
        }
        
        if !validator.check(s: String(format: "%.0f", inventory.margin), regex: .numeric) || inventory.margin <= 0 {
            showError("Margin yang anda masukan tidak valid.")
            finishLoading()
            return false
        }
        
        if !validator.check(s: String(format: "%.0f", inventory.price), regex: .numeric) || inventory.price <= 0 {
            showError("Harga yang anda masukan tidak valid.")
            finishLoading()
            return false
        }
        
        if !validator.check(s: String(inventory.currentStock), regex: .numeric) {
            showError("Jumlah stok barang yang anda masukan tidak valid.")
            finishLoading()
            return false
        }
        
        if !validator.check(s: String(inventory.minimumStock), regex: .numeric){
            showError("Jumlah stok minimal yang anda masukan tidak valid.")
            finishLoading()
            return false
        }
        return true
    }

}

extension CreateInventoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item[section].item.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : item[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 30
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 3 ? "Anda akan diingatkan jika stock dibawah jumlah minimal" : ""
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 3 ? 30 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 192 : 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
            cell.delegate = self
            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
            cell.layoutMargins = UIEdgeInsets.zero
            //load image
            if let tempImage = tempImage {
                cell.imgBarang.image = tempImage
            } else {
                if inventory?.image != "" && inventory?.image != nil {
                    if let uid: String = Preference.getString(forKey: .kUserUid){
                        let placeholderImage = UIImage(named: "photo-camera")!
                        imageRepo.downloadImage(imagePath: inventory!.image, placeholderImage: placeholderImage, to: cell.imgBarang)
                        cell.imgBarang.contentMode = .scaleAspectFill
                        tempImage = cell.imgBarang.image
                    }
                }
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeskripsiProdukTableViewCell", for: indexPath) as! DeskripsiProdukTableViewCell
            let section = indexPath.section
            let row = indexPath.row
            cell.setupView()
            if item[section].required[row] {
                let text = NSMutableAttributedString()
                text.append(NSAttributedString(string: item[section].content[row] , attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
                text.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]))
                cell.nameLabel.attributedText = text
            } else {
                cell.nameLabel.text = item[section].content[row]
            }
            cell.textfield.text = item[indexPath.section].item[indexPath.row]
            cell.indexPath = indexPath
            cell.delegate = self
            if indexPath.section == 1 {
                cell.setUpAlphabet()
            } else {
                cell.setUpNumPad()
            }
            return cell
            
        }
    }
}

extension CreateInventoryVC: FieldCellDelegate {
    
    //when text field is tapped
    func onFieldBeginEditing(text: String, indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.cellForRow(at: indexPath) as! DeskripsiProdukTableViewCell
        if cell.textfield.text != "" {
            switch (section, row) {
            case (2,0), (2,2):
                cell.textfield.text = String(format: "%.0f", item[section].item[row].removeCurrency())
            case (2,1):
                cell.textfield.text = String(item[section].item[row].replacingOccurrences(of: " %", with: ""))
            default:
                break
            }
        }
    }
    
    func onFieldChanging(text: String, indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.cellForRow(at: indexPath) as! DeskripsiProdukTableViewCell
        switch (section, row) {
        case (2,0), (2,2):
            item[section].item[row] = text.currencyInputFormatting()
            cell.textfield.text = item[section].item[row]
        default:
            break
        }
    }
    
    //when text field changes ended
    func onFieldEndEditing(text: String, indexPath: IndexPath) {
        let cost = item[2].item[0].removeCurrency()
        
        switch (indexPath.section, indexPath.row) {
        case (2,0):
            item[indexPath.section].item[indexPath.row] = cost.currencyFormat()
            if !item[2].item[1].elementsEqual("") {
                setupPrice(cost: cost)
            } else if !item[2].item[2].elementsEqual("") {
                setupMargin(cost: cost)
            }
        case (2,1):
            item[indexPath.section].item[indexPath.row] = String(format: "%.0f " , Double(text) ?? 0.0) + "%"
            setupPrice(cost: cost)
        case (2,2):
            let price = text.removeCurrency()
            item[indexPath.section].item[indexPath.row] = price.currencyFormat()
            setupMargin(cost: cost)
        default:
            item[indexPath.section].item[indexPath.row] = text.uppercased()
        }
        tableView.reloadData()
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    private func setupPrice(cost: Double) {
        let text = item[2].item[1]
        let percentage: String = text.contains(" %") ? text.replacingOccurrences(of: " %", with: "") : text
        guard let margin = Double(percentage) else {return}
        let price = cost + (cost * (margin * 0.01))
        item[2].item[2] = price.currencyFormat()
    }
    
    private func setupMargin(cost: Double) {
        let price = item[2].item[2].removeCurrency()
        let margin = ((price - cost) / cost) * 100
        item[2].item[1] = String(format: "%.0f " , margin) + "%"
    }
}

extension CreateInventoryVC: PhotoTableViewCellDelegate {
    func selectImage(_ sender: UIView) {
        imagePicker.present(from: sender)
    }
}

extension CreateInventoryVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let image = image {
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PhotoTableViewCell
            cell.imgBarang.image = image
            cell.imgBarang.contentMode = .scaleAspectFill
            self.imageData = UIImage.pngData(image)()
            self.tempImage = image
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}
