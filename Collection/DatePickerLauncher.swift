//
//  DatePickerLauncher.swift
//  DentalDial
//
//  Created by Sarath R on 1/5/17.
//  Copyright © 2016 Offshorent Solutions. All rights reserved.
//

import UIKit

protocol DateSelectorDelegate {
    func dateDidChange(date: String)
}

class DatePickerLauncher: NSObject {
    
    // Declarations
    var delegate: DateSelectorDelegate?
    let blackView = UIView()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = UIColor.white
        return picker
    }()
    
    
    // MARK: Arrange
    func showDatePicker() {
        //show menu
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            
            datePicker.addTarget(self, action: #selector(DatePickerLauncher.dateChanged(_:)), for: .valueChanged)
            window.addSubview(datePicker)
            
            
            let height: CGFloat = 240
            let y = window.frame.height - height
            datePicker.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.datePicker.frame = CGRect(x: 0, y: y, width: self.datePicker.frame.width, height: self.datePicker.frame.height)
                
            }, completion: nil)
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.datePicker.frame = CGRect(x: 0, y: window.frame.height, width: self.datePicker.frame.width, height: self.datePicker.frame.height)
            }
            
        })
    }
    
    
    
    // MARK: Events
    func dateChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        let selectedDate = dateFormatter.string(from: sender.date)
        
        // Notify selected value
        delegate?.dateDidChange(date: selectedDate)
        
    }
}







