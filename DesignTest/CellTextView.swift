//
//  CellTextView.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 29/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

protocol CustomTextViewDelegate{
    func finishEdit(cellRow: Int)
}

class CellTextView: UITextView {

    var customDelegate: CustomTextViewDelegate?
    var cellRow: Int?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createGestureRecognizer()
    }
    
    func createGestureRecognizer(){
        let gesture = UITapGestureRecognizer(target: self, action: "handleTap")
        self.addGestureRecognizer(gesture)
    }
    
    func handleTap(){
        self.customDelegate?.finishEdit(self.cellRow!)
    }
}
