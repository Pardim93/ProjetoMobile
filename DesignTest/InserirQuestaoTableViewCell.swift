//
//  InserirQuestaoTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 28/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirQuestaoTableViewCell: UITableViewCell{
    
    @IBOutlet weak var descricaoTextView: CellTextView!
    @IBOutlet weak var timesUsedLabel: UILabel!
    @IBOutlet weak var disciplinaLabel: UILabel!
    
    
    var questao: PFObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.setDescricao()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    Config
    func setInfo(){
        self.setDescricao()
        self.setTimesUsed()
        self.setDisciplina()
    }
    
    func setDescricao(){
        guard let descricao = questao!.objectForKey("Descricao") as? String else{
            descricaoTextView.text = "erro"
            return
        }
        
        self.descricaoTextView.text = descricao
        self.configTextView()
    }
    
    func setTimesUsed(){
        guard let timesUsed = questao!.objectForKey("TimesUsed") as? NSNumber else{
            timesUsedLabel.text = "?"
            return
        }
        
        timesUsedLabel.text = "Usada: \(timesUsed) vezes!"
    }
    
    func setDisciplina(){
        guard let disciplina = questao!.objectForKey("Disciplina") as? String else{
            disciplinaLabel.text = "?"
            return
        }
        
        disciplinaLabel.text = disciplina
    }
    
    func configTextView(){
        self.descricaoTextView.layer.borderWidth = 0.3
        self.descricaoTextView.layer.cornerRadius = 5
        self.descricaoTextView.font = UIFont(name: "Avenir Book", size: 15)
        self.descricaoTextView.textColor = UIColor.newBlueColor()
        self.descricaoTextView.userInteractionEnabled = true
    }
}
