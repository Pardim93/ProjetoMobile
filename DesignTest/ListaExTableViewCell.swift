//
//  ListaExTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ListaExTableViewCell: UITableViewCell, EDStarRatingProtocol {
    
    @IBOutlet weak var descricaoTextView: CellTextView!
    @IBOutlet weak var disciplinaLabel: UILabel!
    @IBOutlet weak var starRating: EDStarRating! = EDStarRating()
    
    var questao: PFObject?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToSuperview(newWindow)
//        self.configStars()
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
        self.descricaoTextView.backgroundColor = UIColor.colorWithHexString("EBEFFF", alph: 0.5)
    }
    
    func configStars(){
//        self.starRating = EDStarRating()
        starRating.delegate = self;
        starRating.backgroundColor = UIColor.clearColor()
        starRating.starImage = UIImage(named: "Star-20")
        starRating.starHighlightedImage = UIImage(named: "Star Filled-20")
        starRating.maxRating = 5
        starRating.horizontalMargin = 12;
        starRating.editable = false
        starRating.displayMode = UInt(EDStarRatingDisplayFull)
        starRating.rating = 2.5;
        
//        starRating.frame = CGRectMake(175, 0, 150, 50)
    }
    
//    MARK: Set
    func setInfo(newQuestao: PFObject, newRow: Int){
        self.questao = newQuestao
        self.setDescricao()
        self.setDisciplina()
        
        self.configStars()
        
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
//        self.disciplinaLabel.backgroundColor = UIColor.newPearlColor()
        self.disciplinaLabel.layer.cornerRadius = 15
        self.disciplinaLabel.clipsToBounds = true
        self.disciplinaLabel.layer.borderWidth = 0.3
        
        self.disciplinaLabel.font = UIFont(name: "Avenir Book", size: 15)
        
        if(discString == "Matemática"){
            self.disciplinaLabel.textColor = UIColor.redColor()
            return
        }
        
        if(discString == "Gramática"){
            self.disciplinaLabel.textColor = UIColor.blueColor()
            return
        }
        
        if(discString == "Inglês"){
            self.disciplinaLabel.textColor = UIColor.greenColor()
            return
        }
        
        self.disciplinaLabel.textColor = UIColor.brownColor()
    }
}
