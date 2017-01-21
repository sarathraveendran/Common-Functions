//
//  ValueTranfer.swift
//  
//
//  Created by Sarath on 15/11/16.
//  Copyright © 2016 Sarath R. All rights reserved.
//

import Foundation
import UIKit

class LoginUserDataToDataValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return Data.self as! AnyClass
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        
        //Perform transformation
        guard let data = value as? LoginModal else { return nil }
        return NSKeyedArchiver.archivedData(withRootObject: data)
        
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        //Revert transformation
        guard let data = value as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
    
}

