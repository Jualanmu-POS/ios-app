//
//  DeskripsiProdukTableViewCell.swift
//  JualanMu
//
//  Created by Hendy Sen on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

protocol FieldCellDelegate: class {
    func onFieldBeginEditing(text: String, indexPath: IndexPath)
    func onFieldChanging(text: String, indexPath: IndexPath)
    func onFieldEndEditing(text: String, indexPath: IndexPath)
}

class DeskripsiProdukTableViewCell: UITableViewCell {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    var indexPath: IndexPath!
    weak var delegate: FieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        textfield.delegate = self
        contentView.tapGesture {
            self.textfield.becomeFirstResponder()
        }
    }
    
    func setUpNumPad() {
        textfield.keyboardType = UIKeyboardType.numberPad
    }
    
    func setUpAlphabet() {
        textfield.keyboardType = UIKeyboardType.alphabet
        textfield.autocorrectionType = .no
    }
    
    @IBAction func onFieldChanging(_ sender: UITextField) {
        delegate?.onFieldChanging(text: sender.text ?? "", indexPath: indexPath)
    }
}

extension DeskripsiProdukTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.onFieldBeginEditing(text: textField.text ?? "", indexPath: indexPath)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.onFieldEndEditing(text: textField.text ?? "", indexPath: indexPath)
    }
}
