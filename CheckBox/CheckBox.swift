//
//  CheckBoxClick.swift

//  Created by Sarath R on 26/12/16.
//  Copyright © 2016 Sarath R. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    // Images
    let checkedImage = UIImage(named: "check-sign-fill")! as UIImage
    let uncheckedImage = UIImage(named: "check-sign")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isChecked = false
        self.imageView?.contentMode = .scaleAspectFit
        self.addTarget(self, action: #selector(CheckBox.didSelectCheckBox(_:)), for: .touchUpInside)
    }
    
   
    func didSelectCheckBox(_ sender: CheckBox) {
        sender.isChecked = !sender.isChecked
    }
    
}
