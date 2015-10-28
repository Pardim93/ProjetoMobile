//
//  InserirExTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 22/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirExTableViewCell: UITableViewCell {
    
    @IBOutlet weak var altLabel: UILabel!
    @IBOutlet weak var textView: InserirTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func respostaValida() -> Bool{
        self.textView.makeRed()
        
        guard self.textView != nil else{
            return false
        }
        
        if(self.textView.placeHolderActive){
            return false
        }
        
        guard let text = self.textView.text else{
            return false
        }
        
        if let _ = text.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()){
            self.textView.makeBlack()
            return true
        }
        
        if let _ = text.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()){
            self.textView.makeBlack()
            return true
        }
        
        return false
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
}
