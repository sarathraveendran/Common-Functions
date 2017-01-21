//
//  RadioButton.swift
//  
//
//  Created by Sarath R on 03/01/17.
//  Copyright © 2017 Sarath R. All rights reserved.
//

import UIKit

@IBDesignable
class RadioButton: UIButton {
    
    
    @IBInspectable public var checkedImageName = "checkbox_checked_rose" {
        didSet {
            refreshImages()
        }
    }
    @IBInspectable public var uncheckedImageName = "checkbox_unchecked_rose" {
        didSet {
            refreshImages()
        }
    }
    
    // Images
    var checkedImage = UIImage(named: "checkbox_checked_rose")! as UIImage
    var uncheckedImage = UIImage(named: "checkbox_unchecked_rose")! as UIImage
    
    
    // Bool property
    override var isSelected: Bool {
        didSet{
            if isSelected == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSelected = false
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    // Refresh new Images
    func refreshImages() {
        
        checkedImage = UIImage(named: checkedImageName)! as UIImage
        uncheckedImage = UIImage(named: uncheckedImageName)! as UIImage
        if isSelected == true {
            self.setImage(checkedImage, for: .normal)
        }
        else {
            self.setImage(uncheckedImage, for: .normal)
        }
        
    }
   
}
