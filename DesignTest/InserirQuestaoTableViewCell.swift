//
//  InserirQuestaoTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 28/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

protocol TratarQuestaoDelegate{
    func tratarQuestao(questao: PFObject, buttonStatus: InserirQuestaoProvaButtonStatus)
}

class InserirQuestaoTableViewCell: UITableViewCell{
    
    @IBOutlet weak var descricaoTextView: CellTextView!
    @IBOutlet weak var disciplinaLabel: UILabel!
    @IBOutlet weak var adicionarButton: ZFRippleButton!
    
    var questao: PFObject?
    var delegate: TratarQuestaoDelegate?
    var buttonStatus: InserirQuestaoProvaButtonStatus = .Adicionar
//    var willAdd = true
    
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
//        self.descricaoTextView.layer.borderWidth = 0.3
        self.descricaoTextView.layer.cornerRadius = 5
        self.descricaoTextView.font = UIFont(name: "Avenir Book", size: 15)
        self.descricaoTextView.userInteractionEnabled = true
    }
    
    func configAddButton(){
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
        
        self.disciplinaLabel.text = discString
        self.disciplinaLabel.backgroundColor = UIColor.newPearlColor()
        self.disciplinaLabel.layer.cornerRadius = 15
        self.disciplinaLabel.clipsToBounds = true
        self.disciplinaLabel.layer.borderWidth = 0.3
        
        self.disciplinaLabel.font = UIFont(name: "Avenir Book", size: 15)
    }
    
    func setButtonStatus(newButtonStatus: InserirQuestaoProvaButtonStatus){
        self.buttonStatus = newButtonStatus
        
        switch self.buttonStatus{
        case .Adicionar:
            self.adicionarButton.setTitle("Adicionar", forState: UIControlState.Normal)
            self.adicionarButton.backgroundColor = UIColor.colorWithHexString("007AFF", alph: 1.0)
            self.adicionarButton.rippleBackgroundColor = UIColor.colorWithHexString("007AFF", alph: 0.5)
            self.adicionarButton.rippleColor = UIColor.colorWithHexString("0F3B5F", alph: 1.0)
            break
            
        case .Remover:
            self.adicionarButton.setTitle("Remover", forState: UIControlState.Normal)
            self.adicionarButton.backgroundColor = UIColor.colorWithHexString("C51419", alph: 1.0)
            self.adicionarButton.rippleBackgroundColor = UIColor.colorWithHexString("C51419", alph: 0.5)
            self.adicionarButton.rippleColor = UIColor.colorWithHexString("791619", alph: 1.0)
            break
            
        case .Editar:
            self.adicionarButton.setTitle("Editar", forState: UIControlState.Normal)
            self.adicionarButton.backgroundColor = UIColor.colorWithHexString("00D126", alph: 1.0)
            self.adicionarButton.rippleBackgroundColor = UIColor.colorWithHexString("00D126", alph: 0.5)
            self.adicionarButton.rippleColor = UIColor.colorWithHexString("007D17", alph: 1.0)
            break
        }
    }
    
//    MARK: Button
    @IBAction func usarQuestao(sender: AnyObject) {
        self.delegate?.tratarQuestao(self.questao!, buttonStatus: self.buttonStatus)
        
        if(buttonStatus == InserirQuestaoProvaButtonStatus.Adicionar){
            self.setButtonStatus(InserirQuestaoProvaButtonStatus.Remover)
            return
        }
        
        if(buttonStatus == InserirQuestaoProvaButtonStatus.Remover){
            self.setButtonStatus(InserirQuestaoProvaButtonStatus.Adicionar)
            return
        }
    }
}

enum InserirQuestaoProvaButtonStatus{
    case Adicionar
    case Remover
    case Editar
}
