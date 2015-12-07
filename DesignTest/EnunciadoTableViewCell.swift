//
//  EnunciadoTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 02/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class EnunciadoTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: InserirTextView!
    var oldEnunciado: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configTextView()
    }
    
//    MARK: Config
    
    func configTextView(){
//        self.textView.enableScroll = true
        self.textView.scrollEnabled = true
        self.textView.limitChar = 400
//        self.textView.limitHeight = 100
        self.textView.placeholder = "Enunciado do exercício"
    }
    
    func configOldEnunciado(){
        guard let oldEnun = self.oldEnunciado else{
            return
        }
        
        self.textView.setOldText(oldEnun)
    }
    
//    MARK: CheckConteudo
    func enunciadoValido() -> Bool{
        self.textView.makeRed()
        
        guard self.textView != nil else{
            return false
        }
        
        if(self.textView.placeHolderActive){
            return false
        }
        
        guard
            let text = self.textView.text,
            let _ = text.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) else{
                return false
        }
        
        if (text.characters.count < 5){
            return false
        }
        
        self.textView.makeBlack()
        return true
    }
    
//    MARK: Retorno
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }

}
