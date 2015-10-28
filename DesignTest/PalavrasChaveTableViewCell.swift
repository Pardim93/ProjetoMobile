//
//  PalavrasChaveTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 25/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class PalavrasChaveTableViewCell: UITableViewCell {
    @IBOutlet weak var textView: InserirTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configTextView()
    }
    
//    MARK: Config
    func configTextView(){
        self.textView.enableScroll = true
        self.textView.limitChar = 400
        self.textView.limitHeight = 80
        self.textView.placeholder = "Palavras chave. Separe-as com ,"
    }

//    MARK: CheckConteudo
    func palavrasValidas() -> Bool{
        self.textView.makeRed()
        
        if(self.textView.placeHolderActive){
            return false
        }
        
        guard let text = self.textView.text else{
            return false
        }
        
        guard let _ = text.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) else{
            return false
        }
        
        let auxText = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let arrayTag = auxText.componentsSeparatedByString(",")
        
        for palavraChave in arrayTag{
            guard let _ = palavraChave.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) else{
                return false
            }
            
            if(palavraChave.characters.count < 1){
                return false
            }
        }
        
        self.textView.makeBlack()
        return true
    }
    
//    MARK: Retorno
    func getPalavrasChave() -> [String]{
        let text = self.textView.text
        
        let auxText = text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let arrayTag = auxText.componentsSeparatedByString(",")
        
        return arrayTag
    }
    
//    MARK: Other
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }
}
