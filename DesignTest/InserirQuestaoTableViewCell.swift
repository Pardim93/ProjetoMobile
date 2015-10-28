//
//  InserirQuestaoTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 28/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirQuestaoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descricaoLabel: UILabel!
    
    var questao: PFObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.setDescricao()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDescricao(){
        guard let descricao = questao!.objectForKey("Descricao") as? String else{
            descricaoLabel.text = "erro"
            return
        }
        
        self.descricaoLabel.text = descricao
    }
}
