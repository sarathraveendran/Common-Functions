//
//  String.swift
//  
//
//  Created by Sarath R on 04/10/16.
//  Copyright © 2016 Sarath R. All rights reserved.
//

import Foundation
import UIKit

extension String {
   
    func toBool() -> Bool? {
        
        switch self {
            
            case "True", "true", "yes", "1":
                return true
            case "False", "false", "no", "0":
                return false
            default:
                return nil
            
        }
        
    }
    
    // Remove all white spaces
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}

