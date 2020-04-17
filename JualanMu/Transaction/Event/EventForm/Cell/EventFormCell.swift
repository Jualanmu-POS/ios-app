//
//  EventFormCell.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 12/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class EventFormCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var indexPath: IndexPath!
    weak var delegate: FieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupTapGesture(indexPath: IndexPath) {
        if indexPath.row != 1 && indexPath.row != 2 {
            contentView.tapGesture {
                self.textField.becomeFirstResponder()
            }
            textField.delegate = self
        } else {
            textField.isEnabled = false
        }
        self.indexPath = indexPath
    }
    
    
    
    func setUpNumPad() {
        textField.keyboardType = UIKeyboardType.numberPad
    }
    
    func setUpAlphabet() {
        textField.keyboardType = UIKeyboardType.alphabet
        textField.autocorrectionType = .no
    }
    
}

extension EventFormCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.onFieldEndEditing(text: textField.text ?? "", indexPath: indexPath)
    }
}
