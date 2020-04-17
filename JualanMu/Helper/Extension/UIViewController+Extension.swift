//
//  UIViewController+Extension.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 15/10/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit
import ProgressHUD

extension UIViewController {
    func comingsoonAlert(msg: String = "Ini") {
        let alert = UIAlertController(title: "Fitur \(msg) Akan Segera Hadir. Tunggu Ya :)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke, Semangat!", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func simpleAlert(msg: String, onPositiveTapped: (()->Void)? = nil, onNegativeTapped: (()->Void)? = nil) {
        let alert = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Iya", style: .default, handler: { (_) in
            onPositiveTapped?()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Tidak", style: .destructive, handler: { (_) in
            onNegativeTapped?()
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func startLoading(message: String? = "Sedang mengambil data") {
        ProgressHUD.show(message)
    }
    
    func finishLoading(message: String? = "", showSuccess: Bool = false) {
        if showSuccess {
            ProgressHUD.showSuccess(message)
        } else {
            ProgressHUD.dismiss()
        }
    }
    
    func showError(_ msg: String, completion: (()->Void)? = nil) {
        let alert = UIAlertController(title: "Terjadi kesalahan", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func hideNavigation(shouldHide: Bool) {
        guard let nav = navigationController else {return}
        nav.isNavigationBarHidden = shouldHide
    }
    
    func setupHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
