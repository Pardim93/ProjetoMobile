//
//  TituloTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 25/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class TituloTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titulo: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titulo.layer.borderWidth = 0.3
        titulo.layer.masksToBounds = true
        titulo.layer.cornerRadius = 8
        titulo.placeholder = "Uma breve descrição do seu exercício.\nExemplo: Analisar trecho do livro 'A hora da estrela', de Clarisse Lispector."
    }
    
//    MARK: CheckConteudo
    func tituloValido() -> Bool{
        titulo.layer.borderColor = UIColor.redColor().CGColor
        
        guard let text = self.titulo.text else{
            return false
        }
        
        if (text.characters.count < 5){
            
            return false
        }
        
        guard let _ = text.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) else{
            return false
        }
        
        titulo.layer.borderColor = UIColor.blackColor().CGColor
        return true
    }
    
    //    MARK: Other
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }
}
