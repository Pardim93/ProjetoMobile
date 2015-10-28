//
//  CustomTextField.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 01/09/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRectForBounds(bounds)
        textRect.origin.x += 10
        return textRect
    }
}
