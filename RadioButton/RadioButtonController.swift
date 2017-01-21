//
//  RadioButtonController.swift
//  
//
//  Created by Sarath R on 03/01/17.
//  Copyright © 2017 Sarath R. All rights reserved.
//

import Foundation
import UIKit

@objc protocol RadioButtonControllerDelegate {
    
    @objc optional func didSelectRadioButton(selectedRadio: RadioButton)
}


class RadioButtonController: NSObject {
    
    fileprivate var buttonsArray = [RadioButton]()
    fileprivate weak var currentSelectedButton: RadioButton? = nil
    weak var delegate: RadioButtonControllerDelegate? = nil
    
    
    // Set whether a selected radio button can be deselected or not. Default value is false.
    var shouldLetDeSelect = false
    
    // Variadic parameter init that accepts RadioButton.
    // parameter buttons: Buttons that should behave as Radio Buttons
    init(buttons: RadioButton...) {
        super.init()
        for aButton in buttons {
            aButton.addTarget(self, action: #selector(RadioButtonController.pressed(_:)), for: UIControlEvents.touchUpInside)
        }
        self.buttonsArray = buttons
    }
    
    
    // Add a RadioButton to Controller
    // parameter button: Add the button to controller.
    func addButton(_ aButton: RadioButton) {
        buttonsArray.append(aButton)
        aButton.addTarget(self, action: #selector(RadioButtonController.pressed(_:)), for: UIControlEvents.touchUpInside)
    }
    
    
    // Remove a RadioButton from controller.
    // parameter button: Button to be removed from controller.
    func removeButton(_ aButton: RadioButton) {
        var iteratingButton: RadioButton? = nil
        if(buttonsArray.contains(aButton)) {
            iteratingButton = aButton
        }
        
        if(iteratingButton != nil) {
            buttonsArray.remove(at: buttonsArray.index(of: iteratingButton!)!)
            iteratingButton!.removeTarget(self, action: #selector(RadioButtonController.pressed(_:)), for: UIControlEvents.touchUpInside)
            iteratingButton!.isSelected = false
            if currentSelectedButton == iteratingButton {
                currentSelectedButton = nil
            }
        }
    }
    
    
    // Set an array of UIButons to behave as controller.
    // parameter buttonArray: Array of buttons
    func setButtonsArray(_ aButtonsArray: [RadioButton]) {
        for aButton in aButtonsArray {
            aButton.addTarget(self, action: #selector(RadioButtonController.pressed(_:)), for: UIControlEvents.touchUpInside)
        }
        buttonsArray = aButtonsArray
    }
    
    func pressed(_ sender: RadioButton) {
        if(sender.isSelected) {
            if shouldLetDeSelect {
                sender.isSelected = false
                currentSelectedButton = nil
            }
        } else {
            for aButton in buttonsArray {
                aButton.isSelected = false
            }
            sender.isSelected = true
            currentSelectedButton = sender
        }
        delegate?.didSelectRadioButton?(selectedRadio: currentSelectedButton!)
    }
    
    
    // Get the currently selected button.
    // returns: Currenlty selected button.
    func selectedButton() -> RadioButton? {
        return currentSelectedButton
    }
    
}
