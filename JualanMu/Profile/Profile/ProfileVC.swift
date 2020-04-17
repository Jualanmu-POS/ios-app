//
//  ProfileVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 03/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var isOwner: Bool = false
    var isAnonymous: Bool = false
    
    var user: User?
    var staffs: [User] = []
    var profileItems: [ProfileItem] = []
    var repo: ProfileRepo!
    var imageRepo: ImageStorageRepo! = ImageStorageRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        let auth: FirebaseAuthentication = FirebaseAuthentication(validation: BaseValidation())
        repo = ProfileRepo(auth: auth, userRepo: UserRepo())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Preference.getBool(forKey: .kAnonymity)! {
            onLoginTapped()
        }
        hideNavigation(shouldHide: true)
        setUIComponent()
        setNavbar()
        getProfile()
    }
    
    private func getProfile() {
        if let email: String = Preference.getString(forKey: .kUserEmail) {
            startLoading()
            repo.getProfile(email: email, onSuccess: setupUser(user:)) { (err) in
                self.finishLoading()
                self.showError(err.localizedDescription)
            }
        } else {
            refreshView()
        }
    }
    
    private func getStaff() {
        startLoading()
        repo.getStaf(onSuccess: setupStaff(users:)) { (err) in
            self.finishLoading()
            self.showError(err.localizedDescription)
        }
    }
    
    private func setupUser(user: User) {
        self.user = user
        profileItems = repo.createProfileItems(user: user, numberOfStaff: 0)
        let isOwner = Preference.getBool(forKey: .kIsOwner) ?? false
        if isOwner { getStaff() }
        else { refreshView() }
    }
    
    private func setupStaff(users: [User]) {
        guard let uid = Preference.getString(forKey: .kUserUid) else {return}
        staffs = users.filter({return $0.shopToken == uid && $0.token != uid})
        profileItems[5].content = String(staffs.count - 1)
        refreshView()
        finishLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigation(shouldHide: false)
    }

    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "AnonymousProfileCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AnonymousProfileCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setUIComponent() {
        profileName.text = isAnonymous ? "Guest \(Date().epochTime().prefix(8))" : Preference.getString(forKey: .kUsername)
        profileImage.layer.cornerRadius = 20
    }
    
    func setProfileImage() {
        if user?.image != "" && user?.image != nil {
            if let uid: String = Preference.getString(forKey: .kUserUid) {
                let placeholderImage = UIImage(named: "photo-camera")!
                imageRepo.downloadImage(imagePath: user!.image, placeholderImage: placeholderImage, to: profileImage)
                profileImage.contentMode = .scaleAspectFill
            }
        }
    }
    
    func setNavbar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.9725490196, blue: 0.4196078431, alpha: 1)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = UIColor.black
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isAnonymous ? 1 : profileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isAnonymous {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnonymousProfileCell", for: indexPath) as? AnonymousProfileCell else {return UITableViewCell()}
            tableView.separatorStyle = .none
            cell.setupView()
            cell.delegate = self
            return cell
        } else {
            let item = profileItems[indexPath.row]
            if isOwner {
                return setupOwnerCell(item: item)
            } else {
                return setupStaffCell(item: item)
            }
        }
    }
    
    private func setupOwnerCell(item: ProfileItem) -> UITableViewCell {
        if item.item.elementsEqual("Keluar") || item.item.elementsEqual("Ubah") {
            return setupSingleText(item: item)
        }  else if item.item.elementsEqual("Karyawan") {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = item.item
            cell.detailTextLabel?.text = item.content
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            return setupDefaultView(item: item)
        }
    }
    
    private func setupStaffCell(item: ProfileItem) -> UITableViewCell {
        if item.item.elementsEqual("Keluar") || item.item.elementsEqual("Ubah") {
            return setupSingleText(item: item)
        } else {
            return setupDefaultView(item: item)
        }
    }
    
    private func setupSingleText(item: ProfileItem) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = item.item
        cell.textLabel?.textColor = item.item.elementsEqual("Keluar") ? .red : .black
        cell.textLabel?.textAlignment = .center
        cell.contentView.setupBorder(color: UIColor.gray.withAlphaComponent(0.4), width: 0.5)
        return cell
    }
    
    private func setupDefaultView(item: ProfileItem) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = item.item
        if item.item.elementsEqual("") {
            cell.backgroundColor = .systemGroupedBackground
            cell.isUserInteractionEnabled = false
        } else {
            cell.detailTextLabel?.text = item.content
            cell.contentView.setupBorder(color: UIColor.gray.withAlphaComponent(0.4), width: 0.5)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !isAnonymous {
            let item = profileItems[indexPath.row]
            if item.item.elementsEqual("Ubah") {
                let vc = EditProfileVC()
                vc.profileState = .editProfile
                vc.user = user
                navigationController?.pushViewController(vc, animated: true)
            } else if item.item.elementsEqual("Keluar") {
                simpleAlert(msg: "Apakah kamu yakin ingin keluar dari profilmu?", onPositiveTapped: signOut, onNegativeTapped: nil)
            } else if item.item.elementsEqual("Karyawan") {
                let vc = StaffListVC()
                vc.isOwner = isOwner
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    private func refreshView() {
        finishLoading()
        isAnonymous = Preference.getBool(forKey: .kAnonymity) ?? true
        isOwner = Preference.getBool(forKey: .kIsOwner) ?? false
        setUIComponent()
        tableView.reloadData()
        setProfileImage()
    }
    
    private func signOut() {
        startLoading()
        let auth: FirebaseAuthentication = FirebaseAuthentication(validation: BaseValidation())
        auth.signOut(onSuccess: deleteSession) { (err) in
            self.showError(err.localizedDescription)
        }
    }
    
    private func deleteSession() {
        finishLoading()
        Preference.set(value: true, forKey: .kAnonymity)
        Preference.set(value: false, forKey: .kIsOwner)
        setUIComponent()
        onLoginTapped()
        refreshView()
    }
}

extension ProfileVC: AnonymousCellDelegate {
    func onLoginTapped() {
        let vc = LoginVC()
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        if Preference.getBool(forKey: .kHasLoggedIn)! {navController.modalPresentationStyle = .fullScreen}
        present(navController, animated: true, completion: nil)
    }
    
    func onSignupTapped() {
        let vc = SignupVC()
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
    }
}

extension ProfileVC: LoginDelegate {
    func onLoginDone() {
        dismiss(animated: true, completion: nil)
        Preference.set(value: true, forKey: .kHasLoggedIn)
        getProfile()
    }
}

extension ProfileVC: SignupDelegate {
    func onSignupDone() {
        dismiss(animated: true, completion: nil)
        Preference.set(value: true, forKey: .kHasLoggedIn)
        getProfile()
    }
}
