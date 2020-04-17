//
//  StaffListVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 03/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class StaffListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var users: [User] = []
    private var repo: ProfileRepo!
    private var imageRepo: ImageStorageRepo! = ImageStorageRepo()
    var isOwner = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let auth: FirebaseAuthentication = FirebaseAuthentication(validation: BaseValidation())
        repo = ProfileRepo(auth: auth, userRepo: UserRepo())
        tableViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(shouldHide: false)
        getStaf()
        navBarSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigation(shouldHide: true)
    }
    
    private func getStaf() {
        startLoading()
        guard let uid: String = Preference.getString(forKey: .kUserUid) else {return}
        repo.getStaf(onSuccess: { (users) in
            self.finishLoading()
            self.users = users.filter({return $0.shopToken == uid && $0.token != uid})
            self.tableView.reloadData()
        }) { (err) in
            self.finishLoading()
            self.showError(err.localizedDescription)
        }
    }
    
    func navBarSetup() {
        navigationItem.title = "Data Karyawan"
        navigationItem.rightBarButtonItem = .init(title: "Tambah", style: .done, target: self, action: #selector(addStaff))
    }
    
    @objc func addStaff() {
        let vc = EditProfileVC()
        vc.profileState = .addStaff
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showDeleteAlert(_ indexPath: IndexPath) {
        let message = "Data \(users[indexPath.row].name) akan dihapus"
        let alert = UIAlertController(title: "Hapus karyawan?", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.deleteProfile(self.users[indexPath.row], index: indexPath.row)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteProfile(_ staff: User, index: Int) {
        startLoading(message: "Menghapus karyawan")
        repo.deleteStaf(user: staff, onSuccess: { (_) in
            if staff.image != "" {
                self.imageRepo.deleteImage(imagePath: staff.image)
            }
            self.finishLoading(message: "Berhasil menghapus karyawan", showSuccess: true)
            self.users.remove(at: index)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.tableView.reloadData()
            }
        }) { (err) in
            self.showError(err.localizedDescription)
        }
    }

}

extension StaffListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = EditProfileVC()
        vc.user = users[indexPath.row]
        vc.profileState = .editStaff
        vc.isOwner = isOwner
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(users[indexPath.row].name)"
        return cell
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler:{ (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
//            self.showDeleteAlert(indexPath)
//        })
//
//        return indexPath.row != 0 ? UISwipeActionsConfiguration(actions: [deleteAction]) : nil
//    }
    
}
