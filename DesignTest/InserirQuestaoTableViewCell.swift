//
//  InserirQuestaoTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 28/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

protocol TratarQuestaoDelegate{
    func tratarQuestao(questao: PFObject, willAdd: Bool)
}

class InserirQuestaoTableViewCell: UITableViewCell{
    
    @IBOutlet weak var descricaoTextView: CellTextView!
    @IBOutlet weak var disciplinaLabel: UILabel!
    @IBOutlet weak var adicionarButton: ZFRippleButton!
    
    var questao: PFObject?
    var delegate: TratarQuestaoDelegate?
    var willAdd = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.setDescricao()
        self.configAddButton()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    Config
    func configTextView(){
        self.descricaoTextView.layer.borderWidth = 0.3
        self.descricaoTextView.layer.cornerRadius = 5
        self.descricaoTextView.font = UIFont(name: "Avenir Book", size: 15)
        self.descricaoTextView.userInteractionEnabled = true
    }
    
    func configAddButton(){
        self.adicionarButton.layer.cornerRadius = 5
        self.adicionarButton.layer.borderWidth = 0.5
        self.adicionarButton.layer.borderColor = UIColor.clearColor().CGColor
    }
    
//    MARK: Set
    func setInfo(newQuestao: PFObject, newRow: Int){
        self.questao = newQuestao
        self.setDescricao()
        self.setDisciplina()
        
        self.descricaoTextView.cellRow = newRow
    }
    
    func setDescricao(){
        guard let descricao = questao!.objectForKey("Descricao") as? String else{
            descricaoTextView.text = "erro"
            return
        }
        
        self.descricaoTextView.text = descricao
        self.configTextView()
    }
    
    func setDisciplina(){
        let disciplina = questao!.objectForKey("Disciplina") as! PFObject
        let discString = disciplina.objectForKey("Nome") as! String
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: discString, attributes: underlineAttribute)
        disciplinaLabel.attributedText = underlineAttributedString
        
        self.disciplinaLabel.font = UIFont(name: "Avenir Book", size: 15)
    }
    
    func setButtonStatus(willAdicionar: Bool){
        self.willAdd = willAdicionar
        
        if(self.willAdd){
            self.adicionarButton.setTitle("Adicionar", forState: UIControlState.Normal)
            self.adicionarButton.backgroundColor = UIColor.colorWithHexString("007AFF", alph: 1.0)
            self.adicionarButton.rippleBackgroundColor = UIColor.colorWithHexString("007AFF", alph: 0.5)
            self.adicionarButton.rippleColor = UIColor.colorWithHexString("0F3B5F", alph: 1.0)
        }
        else{
            self.adicionarButton.setTitle("Remover", forState: UIControlState.Normal)
            self.adicionarButton.backgroundColor = UIColor.colorWithHexString("C51419", alph: 1.0)
            self.adicionarButton.rippleBackgroundColor = UIColor.colorWithHexString("C51419", alph: 0.5)
            self.adicionarButton.rippleColor = UIColor.colorWithHexString("791619", alph: 1.0)
        }
    }
    
//    MARK: Button
    @IBAction func usarQuestao(sender: AnyObject) {
        self.delegate?.tratarQuestao(self.questao!, willAdd: self.willAdd)
        self.setButtonStatus(!willAdd)
    }
}
