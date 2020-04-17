//
//  UIImageView+Extension.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 05/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI
import SDWebImage

extension UIImageView {
    func setImage(with reference: StorageReference, placeholder: UIImage? = nil) {
        self.sd_setImage(with: reference, placeholderImage: placeholder) { [weak self] image, _, _, _ in
            reference.getMetadata { metadata, _ in
//                print(NSURL.sd_URL(with: reference)?.absoluteString)
                if let url = NSURL.sd_URL(with: reference)?.absoluteString,
                    let cachePath = SDImageCache.shared.cachePath(forKey: url),
                    let attributes = try? FileManager.default.attributesOfItem(atPath: cachePath),
                    let cacheDate = attributes[.creationDate] as? Date,
                    let serverDate = metadata?.timeCreated,
                    serverDate > cacheDate {
                    
                    SDImageCache.shared.removeImage(forKey: url) {
                        self?.sd_setImage(with: reference, placeholderImage: image, completion: nil)
                    }
                }
            }
        }
    }

}
