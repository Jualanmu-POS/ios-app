//
//  UIView+Extension.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 15/10/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit
enum RadiusType {
    case rounded
    case quarter
    case custom(CGFloat)
}

extension UIView {
    
    fileprivate typealias Action = (() -> Void)?
    
    func setupRadius(type: RadiusType, isMaskToBounds: Bool = true) {
        var radius: CGFloat = 0.0
        
        switch type {
        case .rounded:
            radius = frame.width / 2
        case .quarter:
            radius = frame.width / 4
        case .custom(let value):
            radius = value
        }
        
        layer.cornerRadius = radius
        layer.masksToBounds = isMaskToBounds
    }
    
    func setupBorder(color: UIColor = .black, width: CGFloat = 3) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, color: UIColor = .white) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.backgroundColor = color.cgColor
        layer.mask = mask
    }
    
    func dashedFrame() {
        let border = CAShapeLayer()
        border.strokeColor = UIColor.black.cgColor
        border.lineDashPattern = [4, 4]
        border.frame = bounds
        border.fillColor = nil
        border.path = UIBezierPath(rect: bounds).cgPath
        layer.addSublayer(border)
    }
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    func tapGesture(action: (() -> Void)?) {
        isUserInteractionEnabled = true
        tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = tapGestureRecognizerAction {
            action?()
        }
    }
}

