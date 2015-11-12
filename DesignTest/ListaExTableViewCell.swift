//
//  ListaExTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

protocol ResolverQuestaoDelegate{
    func resolverQuestao(questao: PFObject)
}

class ListaExTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descricaoTextView: CellTextView!
    @IBOutlet weak var disciplinaLabel: UILabel!
    @IBOutlet weak var resolverButton: ZFRippleButton!
    
    var questao: PFObject?
    var delegate: ResolverQuestaoDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configAddButton()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    MARK: Config
    func configTextView(){
        self.descricaoTextView.layer.cornerRadius = 5
        self.descricaoTextView.font = UIFont(name: "Avenir Book", size: 15)
        self.descricaoTextView.userInteractionEnabled = true
    }
    
    func configAddButton(){
        self.resolverButton.layer.borderWidth = 0.5
        self.resolverButton.layer.borderColor = UIColor.clearColor().CGColor
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
    
    @IBAction func resolverButtonTouched(sender: AnyObject) {
        self.delegate?.resolverQuestao(self.questao!)
    }
}
