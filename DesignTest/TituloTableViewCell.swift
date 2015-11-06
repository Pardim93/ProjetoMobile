//
//  TituloTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 25/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class TituloTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var descricaoTextView: InserirTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descricaoTextView.limitHeight = 80
        descricaoTextView.enableScroll = true
        descricaoTextView.limitChar = 400
        descricaoTextView.placeholder = "Uma breve descrição do seu exercício.\nExemplo: Analisar trecho do livro 'A hora da estrela', de Clarisse Lispector."
    }
    
//    MARK: CheckConteudo
    func tituloValido() -> Bool{
        guard let text = self.descricaoTextView.text else{
            descricaoTextView.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
        
        if(descricaoTextView.placeHolderActive){
            descricaoTextView.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
        
        if (text.characters.count < 5){
            descricaoTextView.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
        
        if(!text.hasLetter()){
            descricaoTextView.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
        
        descricaoTextView.layer.borderColor = UIColor.blackColor().CGColor
        return true
    }
    
    //    MARK: Other
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }
}
