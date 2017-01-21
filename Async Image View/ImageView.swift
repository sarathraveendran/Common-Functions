//
//  UIImage.swift
//  ModuleTest
//
//  Created by apple on 17/01/17.
//  Copyright © 2017 Sarath Raveendran. All rights reserved.
//

import Foundation
import UIKit

let logActivity = true
let imageCache = NSCache<NSString, UIImage>()
class ImageView: UIImageView {
    
    var imageUrlString: String?
    
    // Load Image from url
    func loadImageFromUrl(_ urlString: String) {
        
        guard let url = URL(string: urlString) else {
            // Assume error on url generation
            // Default image
            image = UIImage(named: "no_image_icon")
            return
        }
        
        imageUrlString = urlString
        // Place Holder
        self.contentMode = .scaleAspectFit
        image = UIImage(named: "image_loading_icon")
        
        // Cache
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.contentMode = .scaleAspectFill
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                if logActivity { print(error) }
                return
            }
            
            // Display & Cache
            DispatchQueue.main.async(execute: {
                
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                self.contentMode = .scaleAspectFill
                
            })
            
        }).resume()
    }
    
}

