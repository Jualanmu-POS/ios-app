//
//  UIColor+Extension.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 15/10/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(string: String) {
        var chars = Array(string.hasPrefix("#") ? "\(string.dropFirst())" : string)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        switch chars.count {
        case 3:
            chars = [chars[0], chars[0], chars[1], chars[1], chars[2], chars[2]]
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            alpha = 0
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}

extension UIColor {
    @nonobjc class var yellowBorder: UIColor {
        return #colorLiteral(red: 1, green: 0.9725490196, blue: 0.4196078431, alpha: 1)
    }
    @nonobjc class var pinkBorder: UIColor {
        return UIColor(red: 254.0/255.0, green: 104.0/255.0, blue: 136.0/255.0, alpha: 1.0)
    }
}
