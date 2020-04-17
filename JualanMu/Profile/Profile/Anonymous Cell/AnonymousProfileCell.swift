//
//  AnonymousProfileCellTableViewCell.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 03/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

protocol AnonymousCellDelegate: class {
    func onLoginTapped()
    func onSignupTapped()
}

class AnonymousProfileCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    let labelText = "Masuk atau Daftar untuk melihat profil anda"
    let login = "Masuk"
    let signUp = "Daftar"
    
    weak var delegate: AnonymousCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        label.text = labelText
        let formattedText = String.format(strings: [login, signUp],
                                            boldFont: UIFont.boldSystemFont(ofSize: 17),
                                            boldColor: .link,
                                            inString: labelText,
                                            font: UIFont.systemFont(ofSize: 17),
                                            color: UIColor.gray)
        label.attributedText = formattedText
        label.tapGesture {
            guard let gesture = self.label.gestureRecognizers?.first as? UITapGestureRecognizer else {return}
            self.handleTermTapped(gesture: gesture)
        }
    }
    
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        
        let labelString = label.text! as NSString
        let loginRange = labelString.range(of: login)
        let signUpRange = labelString.range(of: signUp)

        if gesture.didTapAttributedTextInLabel(label: label, inRange: loginRange) {
            delegate?.onLoginTapped()
            return
        } else if gesture.didTapAttributedTextInLabel(label: label, inRange: signUpRange) {
            delegate?.onSignupTapped()
            return
        }
    }
    
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
    
}

extension String {
    static func format(strings: [String],
                    boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                    boldColor: UIColor = UIColor.blue,
                    inString string: String,
                    font: UIFont = UIFont.systemFont(ofSize: 14),
                    color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                    attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
}

extension UILabel {
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}
