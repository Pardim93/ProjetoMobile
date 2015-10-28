//
//  AjustesTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class AjustesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var opcaoLabel: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    var imgView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
//    MARK: Getter e Setter
    func setOpcao(texto: String){
        self.opcaoLabel.text = texto
    }
    
    func getOpcao() -> String{
        return self.opcaoLabel.text!
    }

//    MARK: Check
    func createCheck(){
        self.checkImg.image = UIImage(named: "Checkmark-100")
    }
    
    func removeCheck(){
        self.checkImg.image = nil
    }
}
