//
//  ListaProvaTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 10/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ListaProvaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var disciplinasTextView: UITextView!
    @IBOutlet weak var imagemView: UIImageView!
    @IBOutlet weak var numQuestoesLabel: UILabel!
    
    var prova: PFObject?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    MARK: Set
    func setNewProva(novaProva: PFObject){
        self.prova = novaProva
        
        let newTitulo = novaProva.objectForKey("Titulo") as! String
        let disciplinas = novaProva.objectForKey("Disciplinas") as! PFRelation
        let numQuestoes = novaProva.objectForKey("NumQuestoes") as! Int
        
        self.setTitulo(newTitulo)
        self.setDisciplinas(disciplinas)
        self.setNumQuestoes(numQuestoes)
    }
    
    func setTitulo(novoTitulo: String){
        self.tituloLabel.text = novoTitulo
    }
    
    func setDisciplinas(disciplinas: PFRelation){
        let query = disciplinas.query()
        
        do{
            let result = try query?.findObjects()
            
            var newText = ""
            for disc in result!{
                let disciplina = disc
                let discString = disciplina.objectForKey("Nome")
                newText += "\(discString!) - "
            }
            
            newText = String(newText.characters.dropLast())
            newText = String(newText.characters.dropLast())
            
            self.disciplinasTextView.text = newText
            self.disciplinasTextView.font = UIFont(name: "Avenir Book", size: 16)
            self.disciplinasTextView.textColor = UIColor.newLightBlueColor()
        } catch{
            return
        }
        
//        guard let result = query?.findObjects() else{
//            return
//        }
    }
    
    func setNumQuestoes(num: Int){
        self.numQuestoesLabel.text = "\(num) Questões"
    }
    
    func setImage(){
        
    }
}
