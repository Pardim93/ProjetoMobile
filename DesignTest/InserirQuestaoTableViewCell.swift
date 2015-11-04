//
//  InserirQuestaoTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 28/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

protocol TratarQuestaoDelegate{
    func tratarQuestao(questao: PFObject)
}

class InserirQuestaoTableViewCell: UITableViewCell{
    
    @IBOutlet weak var descricaoTextView: CellTextView!
    @IBOutlet weak var disciplinaLabel: UILabel!
    @IBOutlet weak var adicionarButton: ZFRippleButton!
    
    var questao: PFObject?
    var delegate: TratarQuestaoDelegate?
    
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
        guard let disciplina = questao!.objectForKey("Disciplina") as? String else{
            disciplinaLabel.text = "?"
            return
        }
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: disciplina, attributes: underlineAttribute)
        disciplinaLabel.attributedText = underlineAttributedString
        
        self.disciplinaLabel.font = UIFont(name: "Avenir Book", size: 15)
    }
    
//    MARK: Button
    @IBAction func usarQuestao(sender: AnyObject) {
        self.delegate?.tratarQuestao(self.questao!)
    }
}
