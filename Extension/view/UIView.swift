//
//  UIView.swift
//  
//
//  Created by Sarath R on 14/11/16.
//  Copyright © 2016 Sarath R. All rights reserved.
//

import UIKit


extension UIView{
    
    // Dot line border
    func addDashedLineBorder(color:UIColor? = Color().seperator, screenSize: CGSize? = nil) {
        let _ = self.layer.sublayers?.filter({$0.name == "DashedBorder"}).map({$0.removeFromSuperlayer()})
        let shapeRect = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width:self.bounds.size.width, height: self.bounds.size.height)
        
        let  border = CAShapeLayer()
        border.name = "DashedBorder"
        border.strokeColor = color!.cgColor
        border.fillColor = nil
        border.lineDashPattern = [6, 5]
        border.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 20).cgPath
        border.frame = self.bounds
        
        self.layer.addSublayer(border)
    }
    
    
    // Set Constraints
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }

}

  
