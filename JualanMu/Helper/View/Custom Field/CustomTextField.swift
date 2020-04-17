//
//  CustomTextField.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class CustomTextField: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var fieldView: UIView!
    
    var contentView: UIView?
    @IBInspectable var nibName: String?
    
    var text: String {
        return field.text ?? ""
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else {return nil}
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    func build(title: String, hint: String = "") {
        titleLabel.text = title
        field.placeholder = hint
        field.delegate = self
        fieldView.setupBorder(color: .lightGray, width: 1)
    }
    
    func setFocus() {
        field.becomeFirstResponder()
    }
    
    func setSecureEntry() {
        field.isSecureTextEntry = true
    }
    
    func setError(msg: String) {
        errorLabel.text = msg
        errorLabel.isHidden = false
        setFocus()
    }

}

extension CustomTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorLabel.isHidden = true
        return true
    }
}
