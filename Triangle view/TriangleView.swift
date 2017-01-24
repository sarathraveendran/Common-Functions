//
//  TriangleView.swift
//  ModuleTest
//
//  Created by apple on 18/01/17.
//  Copyright © 2017 Sarath Raveendran. All rights reserved.
//

import Foundation
import UIKit

class TriangleView : UIView {
    
    // Declarations
    let colors = Colors()
    
    // MARK: View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
    override func draw(_ rect: CGRect) {
        
        // Get Height and Width
        let layerHeight = layer.frame.height
        let layerWidth = layer.frame.width
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        bezierPath.move(to: CGPoint(x: 0, y: layerHeight))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: layerHeight))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: layerHeight))
        bezierPath.close()
        
        // Apply Color
        colors.feedPageSaleText.setFill()
        bezierPath.fill()
        
        // Mask to Path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }
}

