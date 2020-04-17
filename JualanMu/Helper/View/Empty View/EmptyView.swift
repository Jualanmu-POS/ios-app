//
//  EmptyView.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 13/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionButton: PaddingLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    var contentView: UIView?
    @IBInspectable var nibName: String?

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
    
    func setupView(title: String = "", subtitle: String = "", image: String = "", buttonTitle: String = "") {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle.elementsEqual("")
        actionButton.setupRadius(type: .custom(10.0))
        imageView.image = UIImage(named: image)
        actionButton.text = "+  \(buttonTitle)"
    }
    
    func actionTapped(tap: (()->Void)? = nil) {
        actionButton.tapGesture(action: tap)
    }
    
}
