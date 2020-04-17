//
//  PaddingLabel.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 13/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    @IBInspectable var paddingRight: CGFloat = 0.0
    @IBInspectable var paddingLeft: CGFloat = 0.0
    @IBInspectable var paddingTop: CGFloat = 0.0
    @IBInspectable var paddingBottom: CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)))
    }

    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + paddingLeft + paddingRight
        let heigth = superContentSize.height + paddingTop + paddingBottom
        return CGSize(width: width, height: heigth)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + paddingLeft + paddingRight
        let heigth = superSizeThatFits.height + paddingTop + paddingBottom
        return CGSize(width: width, height: heigth)
    }

}

