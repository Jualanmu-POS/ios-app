//
//  EditProfileVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 03/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

enum ProfileState {
    case editStaff
    case addStaff
    case editProfile
}

class EditProfileVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeImgButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var imagePicker: ImagePicker!
    var profileState: ProfileState = .editProfile
    var imageData: Data!
    var tempImage: UIImage!
    var user: User?
    var isOwner: Bool = true
    
    private var repo: ProfileRepo!
    private var imageRepo: ImageStorageRepo = ImageStorageRepo()
    private var items: [ProfileItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarSetup()
        let auth: FirebaseAuthentication = FirebaseAuthentication(validation: BaseValidation())
        repo = ProfileRepo(auth: auth, userRepo: UserRepo())
        tableViewSetup()
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        items = repo.createEditProfileItems(user: user, type: profileState)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(shouldHide: false)
        navBarSetup()
        setUIComponent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigation(shouldHide: true)
    }
    
    func navBarSetup() {
        switch profileState {
        case .editProfile:
            navigationItem.title = "Ubah Profil"
            navigationItem.rightBarButtonItem = .init(title: "Ubah", style: .done, target: self, action: #selector(editProfile))
        case .editStaff:
            navigationItem.title = "Edit Profil Karyawan"
            navigationItem.rightBarButtonItem = .init(title: "Ubah", style: .done, target: self, action: #selector(editStaff))
            if isOwner {
                changeImgButton.isHidden = true
                profileImage.isUserInteractionEnabled = false
            }
        case .addStaff:
            navigationItem.title = "Tambah Karyawan"
            navigationItem.rightBarButtonItem = .init(title: "Simpan", style: .done, target: self, action: #selector(addStaffProfile))
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func addStaffProfile() {
        let name: String = items[0].content
        let email: String = items[1].content
        let shopName: String = Preference.getString(forKey: .kShopname) ?? "Jualanmu"
        let uid: String = Preference.getString(forKey: .kUserUid)!
        var image: String = ""
        
        if let _ = imageData {
            image = "\(uid)/images/profile/\(name).png"
        }
        
        let staf: User = User(id: 0,
                              shopName: shopName,
                              name: name,
                              email: email,
                              password: String(Date().epochTime().prefix(6)),
                              token: Date().epochTime(),
                              shopToken: uid,
                              image: image,
                              isOwner: false,
                              timestamp: Date().formatDate(),
                              key: "")
        
        startLoading(message: "Menambah staff")
        if let imageData = imageData {
            imageRepo.uploadNewImage(imagePath: staf.image, imageData: imageData, completion: {
                self.addRepoStaff(staf)
            })
        } else {
            addRepoStaff(staf)
        }
    }
    
    @objc func editProfile() {
        let name: String = items[0].content
        let email: String = items[1].content
        let shopName: String = items[2].content
        let uid: String = Preference.getString(forKey: .kUserUid)!
        let isOwner = profileState == .editStaff ? false : true
        let staf: User = User(id: 0,
                              shopName: shopName,
                              name: name,
                              email: email,
                              password: String(Date().epochTime().prefix(6)),
                              token: Date().epochTime(),
                              shopToken: uid,
                              image: "\(uid)/images/profile/\(user!.name).png",
                              isOwner: isOwner,
                              timestamp: Date().formatDate(),
                              key: user!.key
        )
        
        startLoading(message: "Mengubah profil")
        if let imageData = imageData {
            imageRepo.uploadNewImage(imagePath: staf.image, imageData: imageData, completion: {
                self.editRepoStaff(staf)
            })
        } else {
            editRepoStaff(staf)
        }
        
    }
    
    @objc func editStaff() {
        
        let name: String = items[0].content
        let email: String = items[1].content
        let shopName: String = Preference.getString(forKey: .kShopname) ?? "Jualanmu"
        let uid: String = Preference.getString(forKey: .kUserUid)!
        let staf: User = User(id: 0,
                              shopName: shopName,
                              name: name,
                              email: email,
                              password: String(Date().epochTime().prefix(6)),
                              token: Date().epochTime(),
                              shopToken: uid,
                              image: "\(uid)/images/profile/\(user!.name).png",
                              isOwner: true,
                              timestamp: Date().formatDate(),
                              key: user!.key)
        startLoading(message: "Mengubah profil staff")
        if let imageData = imageData {
            imageRepo.updateImage(oldPath: staf.image, newPath: staf.image, imageData: imageData, completion: {
                self.editRepoStaff(staf)
            })
        } else {
            editRepoStaff(staf)
        }
    }
    
    func addRepoStaff (_ staff: User){
        repo.registerStaf(user: staff, onSuccess: { [weak self] (_) in
            guard let self = self else {return}
            self.finishLoading(message: "Staff berhasil ditambah!", showSuccess: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (err) in
            self.finishLoading()
            self.showError(err.localizedDescription)
        }
    }
    
    func editRepoStaff (_ staff: User){
        repo.editProfile(user: staff, onSuccess: { [weak self] (_) in
            guard let self = self else {return}
            self.finishLoading(message: "Profil berhasil diubah!", showSuccess: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (err) in
            self.finishLoading()
            self.showError(err.localizedDescription)
        }
    }
    
    @objc private func deleteProfile() {
        guard let user = user else {return}
        repo.deleteStaf(user: user, onSuccess: { (_) in
            
        }) { (err) in
            self.showError(err.localizedDescription)
        }
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibDeskripsi = UINib.init(nibName: "DeskripsiProdukTableViewCell", bundle: nil)
        tableView.register(nibDeskripsi, forCellReuseIdentifier: "DeskripsiProdukTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }

    func setUIComponent() {
        profileImage.layer.cornerRadius = 20
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
        if profileState != .addStaff {
            if user!.image != "" && user?.image != nil {
                if let uid: String = Preference.getString(forKey: .kUserUid){
                    let placeholderImage = UIImage(named: "photo-camera")!
                    imageRepo.downloadImage(imagePath: user!.image, placeholderImage: placeholderImage, to: profileImage)
                    profileImage.contentMode = .scaleAspectFill
                }
            }
        }
    }

    @IBAction func changeImgButton(_ sender: Any) {
        imagePicker.present(from: profileImage)
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer){
        imagePicker.present(from: profileImage)
    }
    
}

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeskripsiProdukTableViewCell") as? DeskripsiProdukTableViewCell else {return UITableViewCell()}
        cell.setupView()
        cell.nameLabel.text = items[indexPath.row].item
        cell.textfield.text = items[indexPath.row].content
        cell.indexPath = indexPath
        cell.delegate = self
        if profileState == .editStaff && isOwner {cell.textfield.isUserInteractionEnabled = false}
        return cell
    }
}

extension EditProfileVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let image = image {
            profileImage.image = image
            profileImage.contentMode = .scaleAspectFill
            self.imageData = UIImage.pngData(image)()
            self.tempImage = image
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

extension EditProfileVC: FieldCellDelegate {
    func onFieldBeginEditing(text: String, indexPath: IndexPath) {
        
    }
    
    func onFieldChanging(text: String, indexPath: IndexPath) {
        
    }
    
    func onFieldEndEditing(text: String, indexPath: IndexPath) {
        items[indexPath.row].content = text
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
