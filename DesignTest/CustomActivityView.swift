//
//  CustomActivityView.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 30/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class CustomActivityView: UIActivityIndicatorView {
    init(){
        super.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.frame = CGRectMake(0, 0, 50, 50)
        self.color = UIColor.redColor()
        self.hidesWhenStopped = true
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
}
