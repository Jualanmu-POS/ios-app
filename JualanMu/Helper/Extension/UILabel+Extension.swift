//
//  UILabel+Extension.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 15/10/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit
extension UILabel {
    func highlightText(highlightedText text2: String, color: UIColor = .black) {
        guard let text = text else {return}
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text2)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : color], range: range)
        attributedText = attributedString
    }
    
    func underlinedText(underlinedWord text2: String, color: UIColor = .blue) {
        guard let text = text else {return}
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text2)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue], range: range)
        attributedText = attributedString
    }
    
    func boldText(_ boldText: String) {
        guard let text = text else {return}
        let attr = attributedText!.mutableCopy() as! NSMutableAttributedString
        let range = (text as NSString).range(of: boldText)
        if range.location != NSNotFound {
            attr.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)], range: range)
        }
        
        attributedText = attr
    }
}
