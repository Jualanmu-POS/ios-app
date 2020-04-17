//
//  SignupVC.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

protocol SignupDelegate: class {
    func onSignupDone()
}

class SignupVC: UIViewController {

    @IBOutlet weak var shopNameField: CustomTextField!
    @IBOutlet weak var ownerNameField: CustomTextField!
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var confirmationPasswordField: CustomTextField!
    @IBOutlet weak var signinLabel: UILabel!
    @IBOutlet weak var signupButton: CustomButton!
    @IBOutlet weak var contentView: UIView!
    
    weak var delegate: SignupDelegate?
    private var repo: ProfileRepo!
    private var validator: Validation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validator = BaseValidation()
        let auth = FirebaseAuthentication(validation: validator)
        repo = ProfileRepo(auth: auth, userRepo: UserRepo())
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(shouldHide: true)
    }
    
    private func setupView() {
        shopNameField.build(title: "Nama Usaha", hint: "Masukkan Nama Usaha")
        ownerNameField.build(title: "Nama Owner", hint: "Masukkan Nama Owner")
        emailField.build(title: "Email", hint: "Masukkan Email")
        passwordField.build(title: "Kata Sandi", hint: "Masukkan Kata Sandi")
        passwordField.setSecureEntry()
        confirmationPasswordField.build(title: "Konfirmasi Kata Sandi", hint: "Konfirmasi Kata Sandi")
        confirmationPasswordField.setSecureEntry()
        signupButton.initButton(color: .yellowBorder, radius: 20.0)
        signupButton.backgroundColor = .yellowBorder
        signupButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView.layer.cornerRadius = 20.0
        signinLabel.highlightText(highlightedText: "Masuk", color: .link)
        signinLabel.tapGesture {
            self.navigationController?.pushViewController(LoginVC(), animated: true)
        }
    }
    
    @IBAction func onSignupTapped(_ sender: CustomButton) {
        if validator.isEmpty(s: shopNameField.text) {
            shopNameField.setError(msg: "Nama toko kamu belum diisi")
        } else if validator.isEmpty(s: ownerNameField.text) {
            ownerNameField.setError(msg: "Nama kamu belum diisi")
        } else if !validator.check(s: ownerNameField.text, regex: .alphabet) {
            ownerNameField.setError(msg: "Nama kamu belum sesuai format")
        } else if validator.isEmpty(s: emailField.text) {
            emailField.setError(msg: "Email kamu belum diisi")
        } else if !validator.check(s: emailField.text, regex: .email) {
            emailField.setError(msg: "Email kamu belum sesuai format")
        } else if validator.isEmpty(s: passwordField.text) {
            passwordField.setError(msg: "Kata sandi kamu belum diisi")
        } else if validator.isEmpty(s: confirmationPasswordField.text) {
            confirmationPasswordField.setError(msg: "Konfirmasi kata sandi kamu belum diisi")
        } else if !passwordField.text.elementsEqual(confirmationPasswordField.text) {
            confirmationPasswordField.setError(msg: "Kata sandi kamu belum cocok")
        } else {
            guard let uid: String = Preference.getString(forKey: .kUserUid) else {return}
            startLoading()
            let user: User = User(
                id: 0,
                shopName: shopNameField.text,
                name: ownerNameField.text,
                email: emailField.text,
                password: passwordField.text,
                token: uid,
                shopToken: uid,
                image: "",
                isOwner: true,
                timestamp: Date().formatDate(),
                key: "")
            repo.registerShop(user: user, onSuccess: { (_) in
                Preference.saveProfile(user: user)
                self.finishLoading()
                self.delegate?.onSignupDone()
            }, onAuthFailed: { (err) in
                self.finishLoading()
                self.showError(err.localizedDescription)
            }) { (err) in
                self.finishLoading()
                self.showError(err.localizedDescription)
            }
        }
    }

}
