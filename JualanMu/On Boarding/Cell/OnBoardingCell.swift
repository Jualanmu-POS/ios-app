//
//  OnBoardingCell.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class OnBoardingCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var getStartedButton: CustomButton!
    var onStartTapped: (()->Void)?
    
    var onBoarding: OnBoarding! {
        didSet {
            title.text = onBoarding.title
            subtitle.text = onBoarding.subtitle
            image.image = UIImage(named: onBoarding.image)
        }
    }
    
    var index: Int! {
        didSet {
            getStartedButton.initButton(color: .yellowBorder, radius: 12.0)
            getStartedButton.isHidden = index < 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func onGetStartedTapped(_ sender: CustomButton) {
        onStartTapped?()
    }
}
