//
//  LoginVC.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

protocol LoginDelegate: class {
    func onLoginDone()
}

class LoginVC: UIViewController {

    @IBOutlet weak var emailOrIdField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signinButton: CustomButton!
    
    weak var delegate: LoginDelegate?
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
        emailOrIdField.build(title: "Email", hint: "Masukkan Email")
        passwordField.build(title: "Kata Sandi", hint: "Masukkan Kata Sandi")
        passwordField.setSecureEntry()
        signupLabel.highlightText(highlightedText: "Daftarkan", color: .link)
        signinButton.initButton(color: .yellowBorder, radius: 20.0)
        signinButton.backgroundColor = .yellowBorder
        signinButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        signupLabel.tapGesture {
            self.navigationController?.pushViewController(SignupVC(), animated: true)
        }
    }

    @IBAction func onSignInTapped(_ sender: CustomButton) {
        if validator.isEmpty(s: emailOrIdField.text) {
            emailOrIdField.setError(msg: "Isi email kamu terlebih dahulu ya")
        } else if !validator.check(s: emailOrIdField.text, regex: .email) {
            emailOrIdField.setError(msg: "Email kamu tidak sesuai format. Cek kembali")
        } else if validator.isEmpty(s: passwordField.text) {
            passwordField.setError(msg: "Isi kata sandi kamu dulu ya")
        } else {
            startLoading()
            let auth: Authentication = Authentication(email: emailOrIdField.text, password: passwordField.text)
            repo.signIn(authentication: auth, onSuccess: { [weak self] (user) in
                guard let self = self else {return}
                Preference.saveProfile(user: user)
                self.finishLoading()
                self.delegate?.onLoginDone()
            }) { [weak self] (err) in
                guard let self = self else {return}
                self.finishLoading()
                self.showError(err.localizedDescription)
            }
        }
    }

}
