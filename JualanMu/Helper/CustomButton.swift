//
//  CustomButton.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initButton(color: UIColor = .white, radius: CGFloat = 8.0) {
        setupBorder(color: color)
        setupRadius(type: .custom(radius))
    }
}
