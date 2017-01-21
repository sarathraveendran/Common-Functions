//
//  UILabel.swift
//  
//
//  Created by Sarath R on 18/01/17.
//  Copyright © 2017 Sarath Raveendran. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    // Image with Text
    func setImageAndText(titleText: String, imageName: String, alignment: NSTextAlignment? = .center) {
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: imageName)
        imageAttachment.bounds = CGRect(x: -5, y: 0, width: 10, height: 10);
        
        let imageAttachmentString = NSAttributedString(attachment: imageAttachment)
        
        let newStringFormat = NSMutableAttributedString(string: titleText)
        newStringFormat.insert(imageAttachmentString, at: 0)
        
        self.textAlignment = alignment!
        self.attributedText = newStringFormat
        
    }
    
}
