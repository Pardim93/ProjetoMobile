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
//        self.textView.enableScroll = true
        self.textView.scrollEnabled = true
        self.textView.limitChar = 400
//        self.textView.limitHeight = 80
        self.textView.placeholder = "Palavras chave. Separe-as com ,"
    }

//    MARK: CheckConteudo
    func palavrasValidas() -> Bool{
        if(self.textView.placeHolderActive){
            self.textView.makeRed()
            return false
        }
        
        guard let text = self.textView.text else{
            self.textView.makeRed()
            return false
        }
        
        if(!text.hasLetter()){
            self.textView.makeRed()
            return false
        }
        
        let auxText = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let arrayTag = auxText.componentsSeparatedByString(",")
        
        for palavraChave in arrayTag{
            if(!palavraChave.hasLetter()){
                self.textView.makeRed()
                return false
            }
            
            if(palavraChave.characters.count < 1){
                self.textView.makeRed()
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
