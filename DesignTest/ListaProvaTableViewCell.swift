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
    let colors:[UIColor] = [UIColor.newLightBlueColor(), UIColor.newBlueColor()]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    MARK: Set
    func setColor(row: Int){
        let colorPick = row%2
        self.tituloLabel.backgroundColor = self.colors[colorPick]
    }
    
    func setNewProva(novaProva: PFObject, disciplinas: String){
        self.prova = novaProva
        
        let newTitulo = novaProva.objectForKey("Titulo") as! String
        let numQuestoes = novaProva.objectForKey("NumQuestoes") as! Int
        
        self.setTitulo(newTitulo)
        self.setDisciplinas(disciplinas)
        self.setNumQuestoes(numQuestoes)
    }
    
    func setTitulo(novoTitulo: String){
        self.tituloLabel.text = novoTitulo
    }
    
    func setDisciplinas(newText: String){
        self.disciplinasTextView.text = newText
        self.disciplinasTextView.font = UIFont(name: "Avenir Book", size: 16)
        self.disciplinasTextView.textColor = UIColor.newLightBlueColor()
    }
    
    func setNumQuestoes(num: Int){
        self.numQuestoesLabel.text = "\(num) Questões"
    }
    
    func setImage(){
        
    }
}
