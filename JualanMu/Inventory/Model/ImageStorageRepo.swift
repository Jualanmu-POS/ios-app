//
//  ImageStorageRepo.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 10/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
import FirebaseUI
import Firebase
import SDWebImage

class ImageStorageRepo {
    
    //create
    func uploadNewImage(imagePath: String, imageData: Data, completion: @escaping ()->()) {
        let imageRef = Storage.storage().reference().child(imagePath)
        let uploadTask = imageRef.putData(imageData)
        
        uploadTask.observe(.progress) { snapshot in
          // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Image Upload progress: \(percentComplete)%")
        }
        
        uploadTask.observe(.success) { snapshot in
          // Upload completed successfully
            completion()
        }
    }
    
    //read
    func downloadImage(imagePath: String, placeholderImage: UIImage,to imageView: UIImageView) {
        let imageRef = Storage.storage().reference().child(imagePath)
        imageView.setImage(with: imageRef, placeholder: placeholderImage)
    }
    
    //update
    func updateImage(oldPath: String, newPath: String, imageData: Data, completion: @escaping ()->()) {
        if oldPath != newPath {
            deleteImage(imagePath: oldPath)
        }
        uploadNewImage(imagePath: newPath, imageData: imageData, completion: completion)
    }
    
    //delete
    func deleteImage(imagePath: String) {
        let imageRef = Storage.storage().reference().child(imagePath)
        imageRef.delete { error in
          if let error = error {
            print(error)
          } else {
            // File deleted successfully
          }
        }
    }
    
}
