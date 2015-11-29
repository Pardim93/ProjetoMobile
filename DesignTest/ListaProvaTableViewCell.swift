//
//  ListaProvaTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 10/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ListaProvaTableViewCell: UITableViewCell, EDStarRatingProtocol {
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var disciplinasTextView: CellTextView!
    @IBOutlet weak var numQuestoesLabel: UILabel!
    @IBOutlet weak var starRating: EDStarRating!
    
    
    var prova: PFObject?
    let colors:[UIColor] = [UIColor.colorWithHexString("#F7802A", alph: 1.0), UIColor.colorWithHexString("#1F7CFF", alph: 1.0), UIColor.newGreenColor()]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configStars()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    MARK: Set
    func setColor(row: Int){
//        let colorPick = row%3
//        self.tituloLabel.backgroundColor = self.colors[colorPick]
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
        self.disciplinasTextView.scrollEnabled = true
        self.disciplinasTextView.backgroundColor = UIColor.colorWithHexString("EBEFFF", alph: 0.5)
        self.disciplinasTextView.layer.cornerRadius = 5
        self.disciplinasTextView.textColor = UIColor.newLightBlueColor()
    }
    
    func setNumQuestoes(num: Int){
        self.numQuestoesLabel.text = "\(num) Questões"
    }
    
    func setImage(){
        
    }
    
//    MARK: Config
    func configStars(){
        starRating.delegate = self;
        starRating.backgroundColor = UIColor.clearColor()
        starRating.starImage = UIImage(named: "Star-20")
        starRating.starHighlightedImage = UIImage(named: "Star Filled-20")
        starRating.maxRating = 5
        starRating.horizontalMargin = 12;
        starRating.editable = false
        starRating.displayMode = UInt(EDStarRatingDisplayFull)
        starRating.rating = 2.5;
    }
}
