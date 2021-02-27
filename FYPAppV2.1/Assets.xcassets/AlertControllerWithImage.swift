//
//  AlertControllerWithImage.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 27/02/2021.
//

import UIKit

extension UIAlertController{
    func addImage(image: UIImage){
        
        let maxSize = CGSize(width: 245, height: 300)
        let imgSize = image.size
        
        var ratio: CGFloat
        
        if(imgSize.width > imgSize.height){
            ratio = maxSize.width / imgSize.width
        }
        else{
            ratio = maxSize.height / imgSize.height
        }
        
        let scaledSize = CGSize(width: imgSize.width * ratio, height: imgSize.height * ratio)
        let resizedImage = image.imageWithSize(scaledSize)
        
        let imgAction = UIAlertAction(title: "", style: .default, handler: nil)
        
        imgAction.isEnabled = false
        imgAction.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imgAction)
    }
}
